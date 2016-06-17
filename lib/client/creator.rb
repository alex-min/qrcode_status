class Client::Creator
  def self.create(params)
    client = Client.new(params)
    ActiveRecord::Base.transaction do
      client.sanitize_phone!
      client.validate!
      client.set_unique_id!
      client.company = client.user.company
      prise_en_charge = SmsMessage::get_message({
        message_id: :prise_en_charge,
        client: client
      })
      event = ClientEvent.new(prise_en_charge)
      client.client_events.push(event)
      event.send_sms!
      client.save!
      client
    end
  end
end

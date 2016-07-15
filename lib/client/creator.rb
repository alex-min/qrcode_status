class Client::Creator
  def self.create(params)
    params = params.merge(product: map_product_type(params))
    client = Client.new(params)
    ActiveRecord::Base.transaction do
      client.sanitize_phone!
      client.save! unless client.valid?
      client.set_unique_id!
      client.company = client.user.company
      client.demo = true if client.company.demo
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

  private

  def self.map_product_type(params)
    product_name = params[:product].last
    product_type = ProductType.find_or_create_by(name: product_name, company: params[:company], enabled: true)
    product_type.name
  end
end

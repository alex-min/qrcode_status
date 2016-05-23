class SmsMessage
  def self.send_sms(client, message)
    return false if client.has_landline_phone? or client.phone.blank?
    twillo_config = Rails.application.config_for :twillo
    twillo_client = Twilio::REST::Client.new twillo_config['account_sid'], \
                                             twillo_config['auth_token']
    twillo_client.account.messages.create({
                                            :from => twillo_config['root_phone'],
                                            :to => client.phone_data.e164,
                                            :body => message,
                                          })
  rescue Twilio::REST::RequestError => e
    message =  "Failed to send SMS for client #{client.id}: #{e.message}"
    Rails.logger.error message
    raise Exceptions::SMSMessageFailure,
      I18n.t('errors.messages.sms', phone: client.phone)
  end

  def self.send_sms_by_code(client, message_id)
    return if client.processed
    ActiveRecord::Base.transaction do
      event_data = SmsMessage::get_message(message_id: message_id, client: client)
      event = ClientEvent.new(event_data.merge(client: client))
      event.send_sms!
      if event_data[:last_message]
        client.processed = true
      end
      client.client_events.push(event)
      event.save!
      client.save!
    end
  end

  def self.get_message(params = {})
    client = params[:client]
    company = client.company
    user_message = UserMessage.where(code: params[:message_id],
                                     user_id: params[:client].user_id).first
    result = ERB.new(user_message.message).result(binding)
    {
      event_code: user_message.code,
      message: result,
      last_message: user_message.action == 'close_ticket',
      event_name: user_message.title
    }
  end
end

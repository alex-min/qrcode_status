class ClientEvent < ActiveRecord::Base
  belongs_to :client

  def send_sms!
    if self.sms_sent != true
      SmsMessage::send_sms(self.client, self.message)
      self.sms_sent = true
    end
  end

end

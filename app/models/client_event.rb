class ClientEvent < ActiveRecord::Base
  belongs_to :client
  before_save :send_sms

  def send_sms
    if self.sms_sent != true
      SmsMessage::send_sms(self.client, self.message)
      self.sms_sent = true
    end
  end

end

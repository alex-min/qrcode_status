class ClientEvent < ActiveRecord::Base
  belongs_to :client
  has_one :company, :through => :client

  def self.from_company(company)
    joins(:client).where(clients: { company_id: company })
  end

  def send_sms!
    if self.sms_sent != true
      SmsMessage::send_sms(self.client, self.message)
      self.sms_sent = true
    end
  end
end

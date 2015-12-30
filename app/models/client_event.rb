class ClientEvent < ActiveRecord::Base
  belongs_to :client
  before_save :send_sms

  def send_sms
    if self.sms_sent != true
      user = self.client.user
      @client = Twilio::REST::Client.new user.twillo_account_sid, user.twillo_auth_token

      phone = self.client.phone.gsub!(/[ \.]/, '')
      if phone[0] === '0'
        phone = phone[1..10]
      end
      @client.account.messages.create({
                                        :from => user.twillo_root_phone,
                                        :to => "+33#{phone}",
                                        :body => self.event_name,
      })
      self.sms_sent = true
    end
  end

end

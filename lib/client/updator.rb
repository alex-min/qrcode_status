class Client::Updator
  def initialize(client)
    @client = client
  end

  def self.update_by_uniqueid(params)
    client = Client.find_by!(unique_id: params[:unique_id])
    client.sanitize_phone!
    client.assign_attributes(params)
    client.save!
  end

  def mark_as_done(params = {})
    ActiveRecord::Base.transaction do
      SmsMessage::send_sms_by_code(@client, :repair_done) if params[:send_notification] == true
      @client.processed = true
      @client.save!
    end
  end
end

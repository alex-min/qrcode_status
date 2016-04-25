class Client::Updator
  def self.update_by_uniqueid(params)
    client = Client.find_by!(unique_id: params[:unique_id])
    client.sanitize_phone!
    client.assign_attributes(params)
    client.save!
  end
end

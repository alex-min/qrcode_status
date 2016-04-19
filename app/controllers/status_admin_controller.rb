class StatusAdminController < ApplicationController
  include Authenticated

  def index
    @client = Client.find_by!(unique_id: params[:unique_id])
    @messages = UserMessage.where(user: current_user)
    create_client(request) if request.request_method == 'POST'
  end

  private
  def create_client(request)
    message_id = params[:client_event][:event_name].to_sym
    event = SmsMessage::get_message(message_id: message_id, client: @client)
    e = ClientEvent.new(event)
    e.client = @client
    e.save!
    if e.last_message === true
      @client.processed = true
      @client.save!
    end
  end

end

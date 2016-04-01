class StatusAdminController < ApplicationController
  include Authenticated

  def index
    @client = Client.find_by!(unique_id: params[:unique_id])
    @messages = SmsMessage::get_message_list(@client)
    if request.request_method === 'POST'
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

end

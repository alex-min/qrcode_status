class StatusAdminController < ApplicationController
  include Authenticated

  def index
    @client = Client.find_by!(unique_id: params[:unique_id])
    @messages = UserMessage.where(user: current_user)
    sent_event(request) if request.request_method == 'POST'
  end

  private

  def sent_event(request)
    message_id = params[:client_event][:event_name].to_sym
    SmsMessage::send_sms_by_code(@client, message_id)
  end
end

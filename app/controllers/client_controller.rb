class ClientController < ApplicationController
  include Authenticated

  def index
    @clients_done = Client.where(company: current_user.company).done.latest
    @clients_in_progress = Client.where(company: current_user.company).in_progress.latest
  end

  def authorize(params)
    params.require(:client).permit(
      :first_name,
      :last_name,
      :address,
      :postal_code,
      :city,
      :phone,
      :product,
      :product_state,
      :brand,
      :product_name,
      :panne
    )
  end

  def new
    if request.request_method === 'POST'
      client = Client::Creator.create(authorize(params).merge(user: current_user))
      redirect_to client_path(client.unique_id)
    else
      @client = Client.new
    end
  rescue ActiveRecord::RecordInvalid, \
         Exceptions::SMSMessageFailure => e
    @client = Client.new(authorize(params))
    add_notification_error(e.message)
    render :action=>'new'
  end

  def edit
    if request.request_method === 'PATCH'
      update_params = authorize(params).merge(unique_id: params[:unique_id])
      Client::Updator.update_by_uniqueid(update_params)
    end
    @client = get_client_by_unique_id
  end

  def view
    @client = get_client_by_unique_id
  end

  def mark_as_done
    @client = get_client_by_id
    if request.request_method === 'POST'
      notify = params[:send_notification].to_i == 1 ? true : false
      Client::Updator.new(@client).mark_as_done(send_notification: notify)
    end
  rescue ActiveRecord::RecordInvalid, \
         Exceptions::SMSMessageFailure => e
    add_notification_error(e.message)
  end
end

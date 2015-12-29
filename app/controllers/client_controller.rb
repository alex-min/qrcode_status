class ClientController < ApplicationController
  def index
    @clients = Client.all
  end

  def authorize(params)
    params.require(:client).permit(
      :first_name,
      :last_name,
      :address,
      :postal_code,
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
      c = Client.new(authorize(params))
      c.save!
      redirect_to client_path(c.unique_id)
    end
  end

  def edit
    if request.request_method === 'PATCH'
      attrs = authorize(params)
      client = Client.find_by!(unique_id: params[:unique_id])
      client.assign_attributes(attrs)
      client.save!
    end
    @client = Client.find_by!(unique_id: params[:unique_id])
  end

  def view
    @client = Client.find_by!(unique_id: params[:unique_id])
  end
end

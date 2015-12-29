class ClientController < ApplicationController
  def index
  end

  def add
  end

  def edit
    if request.request_method === 'PATCH'
      attrs = params.require(:client).permit(:first_name, :last_name)
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

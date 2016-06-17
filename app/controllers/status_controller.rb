class StatusController < ApplicationController
  def index
  end

  def view
    redirect_to status_admin_path(params[:unique_id]) unless current_user.blank?
    @client = Client.find_by!(unique_id: params[:unique_id])
  end
end

class StatusController < ApplicationController
  def index
  end

  def view
    unless current_user.blank?
      redirect_to status_admin_path(params[:unique_id])
    end
    @client = Client.find_by!(unique_id: params[:unique_id])
  end
end

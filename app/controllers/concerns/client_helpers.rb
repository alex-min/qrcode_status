module ClientHelpers
  def get_client_by_unique_id
    Client.find_by!(unique_id: params[:unique_id], company_id: current_user.company.id)
  end

  def get_client_by_id
    Client.find_by!(id: params[:id], company_id: current_user.company.id)
  end
end

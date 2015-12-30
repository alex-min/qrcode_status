class StatusAdminController < ApplicationController
  before_action :authenticate_user!

  def index
    @client = Client.find_by!(unique_id: params[:unique_id])
    if request.request_method === 'POST'
      event_name = {
        repair_done: 'Réparation terminée',
        repair_in_progress: 'Réparation en cours',
        problem_delay: 'Problème de réception des pièces'
      }[params[:client_event][:event_name].to_sym]
      e = ClientEvent.new(event_name: event_name, event_code: params[:client_event][:event_name])
      e.client = @client
      e.save!
    end
  end

end

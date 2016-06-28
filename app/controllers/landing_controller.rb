class LandingController < ApplicationController
  def index
    if current_user.present?
      redirect_to clients_path
    else
      render layout: 'landing'
    end
  end
end

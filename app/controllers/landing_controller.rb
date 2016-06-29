class LandingController < ApplicationController
  def index
    if logged_in?
      redirect_to clients_path
    else
      render layout: 'landing'
    end
  end
end

class ApplicationController < ActionController::Base
  include Notifications
  include ClientHelpers

  def logged_in?
    current_user.present?
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end

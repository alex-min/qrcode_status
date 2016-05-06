class NotificationsController < ApplicationController
  include Authenticated

  def index
    @notifications = ClientEvent.from_company(current_user.company)
                                .order(created_at: :desc)
  end
end

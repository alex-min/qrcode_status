class UserMessagesController < ApplicationController
  def index
    @user_messages = UserMessage.where(company_id: current_user.company_id)
  end
end

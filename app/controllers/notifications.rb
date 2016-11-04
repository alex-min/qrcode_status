module Notifications
  def add_notification_error(message)
    flash[:alert] ||= []
    flash[:alert] << message
  end

  def add_info_message(message)
    flash[:notice] ||= []
    flash[:notice] << message
  end

  def add_flash(type, message)
    flash[:type] ||= []
    flash[:type] << message
  end
end

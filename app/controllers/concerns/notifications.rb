module Notifications
  def add_notification_error(message)
    @errors ||= []
    @errors.push(message)
  end
end

module Notifications
  def add_notification_error(message)
    @errors ||= []
    @errors.push(message)
  end

  def add_info_message(message)
    @infos ||= []
    @infos.push(message)
  end
end

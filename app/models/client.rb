class Client < ActiveRecord::Base
  before_save :set_unique_id

  def set_unique_id
    if self.unique_id.blank?
      self.unique_id = SecureRandom.urlsafe_base64
    end
  end
end

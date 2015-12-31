class Client < ActiveRecord::Base
  before_save :set_unique_id
  has_many :client_events
  belongs_to :user

  def full_name
    "#{self.first_name.capitalize} #{self.last_name.upcase}"
  end

  def product_full_name
    "#{self.product.humanize.downcase} #{self.brand} #{self.product_name}"
  end

  def set_unique_id
    if self.unique_id.blank?
      self.unique_id = SecureRandom.urlsafe_base64
    end
  end
end

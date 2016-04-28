class Client < ActiveRecord::Base
  before_save :set_unique_id
  has_many :client_events
  belongs_to :user
  belongs_to :company
  before_save :style_name

  validates :phone, phone: { allow_blank: true }

  def self.done
    where(processed: true)
  end

  def self.in_progress
    where(processed: [nil, false])
  end

  def self.latest
    order(created_at: :desc)
  end

  def sanitize_phone!
    self.phone = Phonelib.parse(self.phone).national
  end

  def phone_data
    Phonelib.parse(phone)
  end

  def has_landline_phone?
    phone_data.type === :fixed_line
  end

  def full_name
    "#{self.first_name.try(:capitalize)} #{self.last_name.try(:upcase)}"
  end

  def product_full_name
    if self.product
      "#{self.product.humanize.downcase} #{self.brand} #{self.product_name}"
    else
      nil
    end
  end

  def set_unique_id
    if self.unique_id.blank?
      self.unique_id = SecureRandom.urlsafe_base64
    end
  end

  def style_name
    self.first_name.try(:capitalize!)
    self.last_name.try(:upcase!)
  end

  def last_event
    client_events.last
  end
end

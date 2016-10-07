class Client < ActiveRecord::Base
  has_many :client_events
  belongs_to :user
  belongs_to :company
  belongs_to :product_state
  before_save :style_name

  validates :phone, phone: { allow_blank: true }
  validates :email, email: { allow_blank: true }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :product, presence: true

  def self.done
    where(processed: true)
  end

  def self.in_progress
    where(processed: [nil, false])
  end

  def self.latest
    order(created_at: :desc)
  end

  def sanitized_phone
    if phone.present?
      national_format = Phonelib.parse(self.phone).national
      return national_format if national_format.present?
    end
    return phone
  end

  def sanitize_phone!
    if phone.present?
      national_format = Phonelib.parse(self.phone).national
      self.phone = national_format if national_format.present?
    end
    phone
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

  def full_address
    "#{self.address} - #{self.postal_code} #{self.city}"
  end

  def set_unique_id!
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

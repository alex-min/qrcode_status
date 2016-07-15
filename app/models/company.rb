class Company < ActiveRecord::Base
  has_many :users
  has_many :product_states

  has_attached_file :logo, styles: { medium: "300x300>",
                                     thumb: "100x100>",
                                     small: "50x50>",
                                     avatar: "30x30>" }, default_url: "/images/:style/blank.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  validates :name, presence: true
  validates :siret, presence: true
  validates :address, presence: true
  validates :phone, phone: true
end

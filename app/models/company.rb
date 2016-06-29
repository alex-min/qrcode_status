class Company < ActiveRecord::Base
  has_many :users

  validates :name, presence: true
  validates :siret, presence: true
  validates :address, presence: true
  validates :phone, phone: true
end

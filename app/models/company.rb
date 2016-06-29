class Company < ActiveRecord::Base
  has_many :users

  validates :name, presence: true
  validates :siret, presence: true
end

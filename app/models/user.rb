class User < ActiveRecord::Base
  before_save :set_default_company
  belongs_to :company
  has_many :clients
  has_many :user_messages
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :registerable

  def set_default_company
    if company.blank?
      self.company = Company.find_by(name: I18n.t('default_company_name'))
    end
  end
end

module Authenticated
  extend ActiveSupport::Concern

  if Rails.application.config.try(:authentication).try(:[], :disabled)
    define_method(:current_user) { User.first }
  else
    included do
      before_action :authenticate_user!
    end
  end
end

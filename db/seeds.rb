require 'factory_girl'
require 'faker'

FactoryGirl.factories.clear
FactoryGirl.find_definitions
include FactoryGirl::Syntax::Methods

load "#{Rails.root}/db/seed/admin.rb"
load "#{Rails.root}/db/seed/companies.rb"
load "#{Rails.root}/db/seed/user_messages.rb"
load "#{Rails.root}/db/seed/product_types.rb"
load "#{Rails.root}/db/seed/product_states.rb"
load "#{Rails.root}/db/seed/default_company_sample.rb"

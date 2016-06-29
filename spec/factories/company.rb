FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    siret { Faker::Company.ein }
    website { "https://#{Faker::Internet.domain_name}" }
    address { "#{Faker::Address.street_name} #{Faker::Address.street_address}" }
    phone { Faker::PhoneNumber.phone_number }
  end
end

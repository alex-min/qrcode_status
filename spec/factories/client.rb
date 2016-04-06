FactoryGirl.define do
  factory :client do
    first_name Faker::Name.name
    last_name Faker::Name.name
    address "#{Faker::Address.street_name} #{Faker::Address.street_address}"
    postal_code Faker::Address.postcode
    city Faker::Address.city
    phone '0611111111'

    product 'Iphone'
    brand 'Apple'

    trait :with_invalid_phone do
      phone '0000'
    end
  end
end

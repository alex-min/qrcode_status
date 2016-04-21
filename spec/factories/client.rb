FactoryGirl.define do
  factory :client do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name.upcase
    address "#{Faker::Address.street_name} #{Faker::Address.street_address}"
    postal_code Faker::Address.postcode
    city Faker::Address.city
    phone '0611111111'

    product :smartphone
    product_state :excellent
    brand 'Apple'
    product_name 'Iphone'

    user_id User.first.id

    trait :with_invalid_phone do
      phone '0000'
    end

    trait :with_landline do
      phone '0329617478' # random one
    end

    client_events { build_list(:client_event, 1) }
  end
end

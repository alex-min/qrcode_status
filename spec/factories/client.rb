FactoryGirl.define do
  factory :client do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name.upcase
    address "#{Faker::Address.street_name} #{Faker::Address.street_address}"
    postal_code Faker::Address.postcode
    city Faker::Address.city
    phone '06 11 11 11 11'

    product :smartphone
    product_state :excellent
    brand 'Apple'
    product_name 'Iphone'
    panne 'Je l\'ai fait tomber par terre et après, j\'ai sauté dessus à pieds joints.'

    trait :with_invalid_phone do
      phone '0000'
    end

    trait :with_landline do
      phone '0329617478' # random one
    end

    trait :with_unformated_phone do
      phone '  061 1 1 1   11 11 '
    end

    client_events { build_list(:client_event, 1) }

    after(:build) do |client|
      client.user_id = User.first.id
      client.company = User.first.company
    end
  end
end

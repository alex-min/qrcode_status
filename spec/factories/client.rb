FactoryGirl.define do
  factory :client do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name.upcase }
    address { "#{Faker::Address.street_name} #{Faker::Address.street_address}" }
    postal_code { Faker::Address.postcode }
    city { Faker::Address.city }
    phone '06 11 11 11 11'

    product { ProductType.all.sample.name }
    product_state { ProductState.find_by(name: :excellent, company: company) }
    brand 'Apple'
    product_name 'Iphone'
    panne { UserMessages::BrokenMessages.sample }

    unique_id { SecureRandom.urlsafe_base64 }

    email { Faker::Internet.email }

    trait :without_phone do
      phone nil
    end

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

    user { User.first }
    company { Company.first }
  end
end

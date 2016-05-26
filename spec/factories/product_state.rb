FactoryGirl.define do
  factory :product_state do
    trait :excellent do
      name 'excellent'
      legacy_slug 'excellent'
    end

    company { Company.first }
  end
end

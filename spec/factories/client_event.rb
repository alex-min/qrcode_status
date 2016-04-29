FactoryGirl.define do
  factory :client_event do
    event_name 'Réparation en cours'
    event_code 'repair_in_progress'
    message { "Microdeo - Bonjour #{Faker::Name.first_name} #{Faker::Name.last_name.upcase}.\n"\
              "Votre smartphone Apple Iphone est en cours de réparation, "\
              "nous vous tiendrons informés de l'avancement de la réparation.\n\n"\
              "MESSAGE AUTOMATIQUE. MERCI DE NE PAS REPONDRE." }
    company { Company.first }
  end
end

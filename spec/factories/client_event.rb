FactoryGirl.define do
  factory :client_event do
    event_name 'Réparation en cours'
    event_code 'repair_in_progress'
    message "Microdeo - Bonjour Théo LAURENT.\nVotre smartphone Apple Iphone est en cours de réparation, nous vous tiendrons informés de l'avancement de la réparation.\n\nMESSAGE AUTOMATIQUE. MERCI DE NE PAS REPONDRE."
  end
end

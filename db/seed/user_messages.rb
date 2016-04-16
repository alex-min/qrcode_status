puts "[user_messages]"

admin_user = User.find_by(email: ENV['ADMIN_EMAIL'])

hello = "Microdeo - Bonjour <%= client.full_name %>.\n"
horaires = "\nOuvert du Mardi au Samedi, de 9h à 12h et de 14h à 19h, sauf 18h le Samedi."
end_message = "\n"\
  "MESSAGE AUTOMATIQUE. MERCI DE NE PAS REPONDRE."
message_list = [
  {
    code: :repair_done,
    title: 'Réparation terminée',
    action: :close_ticket,
    message: "#{hello}"\
             "Votre <%= client.product_full_name %> est maintenant réparé, "\
             "vous pouvez venir le chercher à tout moment au magasin."\
             "#{horaires}"\
              "\n#{end_message}",
    user_id: admin_user.id
  },
  {
    code: 'repair_in_progress',
    title: 'Réparation en cours',
    message: "#{hello}"\
             "Votre <%= client.product_full_name %> est en cours de réparation, "\
             "nous vous tiendrons informés de l'avancement de la réparation.\n"\
             "#{end_message}",
    user_id: admin_user.id
  },{
    code: 'problem_delay',
    title: 'Problème de réception des pièces',
    message: "#{hello}"\
             "Nous avons des problèmes de réception des pièces pour votre "\
             "<%= client.product_full_name %> et la réparation est actuellement retardée.\n"\
             "Vous serez tenu informé de l'évolution de la réparation.\n"\
             "#{end_message}",
    user_id: admin_user.id
  },{
    code: 'prise_en_charge',
    title: 'Prise en charge du produit',
    message: "#{hello}"\
              "Votre <%= client.product_full_name %> est pris en charge.\n"\
              "Vous serez tenu informé de l'évolution de la réparation.\n"\
              "#{end_message}",
    user_id: admin_user.id
  }]
ActiveRecord::Base.transaction do
  message_list.each do |message|
    if UserMessage.where(user: admin_user, code: message[:code]).present?
      puts "[~] UserMessage #{message[:code]} already exists, passing..."
    else
      UserMessage.create!(message)
      puts "[+] Created UserMessage #{message[:code]}."
    end
  end
end

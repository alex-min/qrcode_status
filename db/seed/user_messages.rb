puts "[user_messages]"

admin_user = User.find_by(email: ENV['ADMIN_EMAIL'])
company = admin_user.company

def create_messages(company, user_id)
  hello = "<%= company.name %> - Bonjour <%= client.full_name %>.\n"
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
      user_id: user_id,
      company: company
    },
    {
      code: 'repair_in_progress',
      title: 'Réparation en cours',
      message: "#{hello}"\
               "Votre <%= client.product_full_name %> est en cours de réparation, "\
               "nous vous tiendrons informés de l'avancement de la réparation.\n"\
               "#{end_message}",
      user_id: user_id,
      company: company
    },{
      code: 'problem_delay',
      title: 'Problème de réception des pièces',
      message: "#{hello}"\
               "Nous avons des problèmes de réception des pièces pour votre "\
               "<%= client.product_full_name %> et la réparation est actuellement retardée.\n"\
               "Vous serez tenu informé de l'évolution de la réparation.\n"\
               "#{end_message}",
      user_id: user_id,
      company: company
    },{
      code: 'prise_en_charge',
      title: 'Prise en charge du produit',
      message: "#{hello}"\
                "Votre <%= client.product_full_name %> est pris en charge.\n"\
                "Vous serez tenu informé de l'évolution de la réparation.\n"\
                "#{end_message}",
      user_id: user_id,
      company: company
    }]
  ActiveRecord::Base.transaction do
    message_list.each do |message|
      if UserMessage.where(user_id: user_id,
                           code: message[:code],
                           company: company).present?
        puts "[~] UserMessage #{message[:code]} already exists, passing..."
      else
        # :nocov:
        UserMessage.create!(message)
        puts "[+] Created UserMessage #{message[:code]}."
        # :nocov:
      end
    end
  end
end

default_company_name = I18n.t('default_company_name')

create_messages(company, admin_user.id)
create_messages(Company.find_by(name: default_company_name), nil)

puts ""

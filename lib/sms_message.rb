class SmsMessage
  def self.get_message_list(client)
    hello = "Microdeo - Bonjour #{client.full_name}.\n"
    horaires = "\nOuvert du Mardi au Samedi, de 9h à 12h et de 14h à 19h, sauf 18h le Samedi."
    end_message = "\n"\
      "MESSAGE AUTOMATIQUE. MERCI DE NE PAS REPONDRE."
    {
      repair_done: {event_code:'repair_done', event_name: 'Réparation terminée',
                    message: "#{hello}" \
                    "Votre #{client.product_full_name} est maintenant réparé, vous pouvez venir le chercher à tout moment au magasin."\
                    "#{horaires}"\
                    "\n#{end_message}",
                    last_message: true
                    },
      repair_in_progress: {event_code: 'repair_in_progress', event_name: 'Réparation en cours',
                           message: "#{hello}"\
                           "Votre #{client.product_full_name} est en cours de réparation, nous vous tiendrons informés de l'avancement de la réparation.\n#{end_message}"},
      problem_delay: { event_code: 'problem_delay', event_name: 'Problème de réception des pièces',
                       message: "#{hello}"\
                       "Nous avons des problèmes de réception des pièces pour votre #{client.product_full_name} et la réparation est actuellement retardée.\n"\
                       "Vous serez tenu informé de l'évolution de la réparation.\n"\
                       "#{end_message}"},

      prise_en_charge: { event_code: 'prise_en_charge', event_name: 'Prise en charge du produit',
                         message: "#{hello}"\
                         "Votre #{client.product_full_name} est pris en charge.\n"\
                         "Vous serez tenu informé de l'évolution de la réparation.\n"\
                         "#{end_message}",
                         show_on_list: false
                         }

    }
  end

  def self.send_sms(client, message)
      user = client.user
      twillo_client = Twilio::REST::Client.new user.twillo_account_sid, \
                                               user.twillo_auth_token
      twillo_client.account.messages.create({
                                              :from => user.twillo_root_phone,
                                              :to => Phonelib.parse(client.phone).e164,
                                              :body => message,
                                            })
  rescue Twilio::REST::RequestError => e
    message =  "Failed to send SMS for client #{client.id}: #{e.message}"
    Rails.logger.error message
    raise Exceptions::SMSMessageFailure,
      I18n.t('errors.messages.sms', phone: client.phone)
  end

  def self.get_message(params = {})
    client = params[:client]
    message_id = params[:message_id].to_sym
    self.get_message_list(client)[message_id]
  end
end

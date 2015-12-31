class SmsMessages
  def self.get_message_list(client)
    end_message = "\n"\
      "Merci de ne pas répondre à ce message, les réponses ne seront pas lues."
    {
      repair_done: {event_code:'repair_done', event_name: 'Réparation terminée',
                    message: "Microdeo - Bonjour #{client.full_name}.\n" \
                    "Votre #{client.product_full_name} est maintenant réparé, vous pouvez venir le chercher à tout moment au magasin.#{end_message}"},
      repair_in_progress: {event_code: 'repair_in_progress', event_name: 'Réparation en cours',
                           message: "Microdeo - Votre appareil est en cours de réparation, nous vous tiendrons informés.#{end_message}"},
      problem_delay: { event_name: 'problem_delay', event_name: 'Problème de réception des pièces',
                       message: 'Microdeo - Nous avons des problèmes de réception des pièces#{end_message}'},

      prise_en_charge: { event_name: 'prise_en_charge', event_name: 'Prise en charge du produit',
                         message: 'Microdeo - Votre produit est pris en charge.#{end_message}'}

    }
  end

  def self.get_message(params = {})
    client = params[:client]
    message_id = params[:message_id].to_sym
    self.get_message_list(client)[message_id]
  end
end

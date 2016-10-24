class Company::Creator
  def initialize(user:,
                 company_data:)
    @user = user
    @company_data = company_data
  end

  def assign
    ActiveRecord::Base.transaction do
      company = Company.create!(@company_data.merge(users: [@user]))
      company.product_states.create!(product_states_list.map { |name| { name: name } })
      create_base_message
      company
    end
  end

  private

  def create_base_message
    UserMessage.create!([startrepair_message])
  end

  def problem_delay_message
    {
      code: 'problem_delay',
      title: 'Problème de réception des pièces',
      message: "#{message_hello}"\
               "Nous avons des problèmes de réception des pièces pour votre "\
               "<%= client.product_full_name %> et la réparation est actuellement retardée.\n"\
               "Vous serez tenu informé de l'évolution de la réparation.\n"\
               "#{end_message}",
      user: @user,
      company: @company
    }
  end

  def startrepair_message
    {
      code: 'prise_en_charge',
      title: 'Prise en charge du produit',
      message: "#{message_hello}\n"\
                "Votre <%= client.product_full_name %> est pris en charge.\n"\
                "Vous serez tenu informé de l'évolution de la réparation.\n"\
                "MESSAGE AUTOMATIQUE. MERCI DE NE PAS REPONDRE.",
      user: @user,
      company: @company
    }
  end


  def basemessage_hello
    "<%= company.name %> - Bonjour <%= client.full_name %>."
  end

  def product_states_list
    %w(excellent bon moyen mauvais)
  end
end

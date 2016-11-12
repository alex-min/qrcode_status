class Company::Creator
  def initialize(user:,
                 company:)
    @user = user
    @company_data = company_data
  end

  def assign
    ActiveRecord::Base.transaction do
      @company = Company.create!(@company_data.merge(users: [@user]))
      @company.product_states.create!(product_states_list.map { |name| { name: name } })
      create_base_message
      @company
    end
  end

  private

  def create_base_message
    UserMessage.create!([
          startrepair_message,
          problem_delay_message,
          repair_in_progress_message,
          repair_done_message
        ])
  end

  def repair_done_message
    {
      code: :repair_done,
      title: 'Réparation terminée',
      action: :close_ticket,
      message: "#{hello}"\
               "Votre <%= client.product_full_name %> est maintenant réparé, "\
               "vous pouvez venir le chercher à tout moment au magasin.\n"\
               "#{end_message}",
      user: @user,
      company: @company
    }
  end

  def repair_in_progress_message
    {
      code: 'repair_in_progress',
      title: 'Réparation en cours',
      message: "#{hello}"\
               "Votre <%= client.product_full_name %> est en cours de réparation, "\
               "nous vous tiendrons informés de l'avancement de la réparation.\n"\
               "#{end_message}",
      user: @user,
      company: @company
    }
  end

  def problem_delay_message
    {
      code: 'problem_delay',
      title: 'Problème de réception des pièces',
      message: "#{hello}"\
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
      message: "#{hello}\n"\
                "Votre <%= client.product_full_name %> est pris en charge.\n"\
                "Vous serez tenu informé de l'évolution de la réparation.\n"\
                "MESSAGE AUTOMATIQUE. MERCI DE NE PAS REPONDRE.",
      user: @user,
      company: @company
    }
  end

  def end_message
    'MESSAGE AUTOMATIQUE. MERCI DE NE PAS REPONDRE.'
  end

  def hello
    "<%= company.name %> - Bonjour <%= client.full_name %>."
  end

  def product_states_list
    %w(excellent bon moyen mauvais)
  end
end

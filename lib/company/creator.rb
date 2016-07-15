class Company::Creator
  def self.assign(user, params)
    ActiveRecord::Base.transaction do
      company = Company.create!(params.merge(users: [user]))
      company.product_states.create!(product_states_list.map { |name| { name: name } })
      create_base_message(user, company)
      company
    end
  end

  private

  def self.create_base_message(user, company)
    UserMessage.create!({
      code: 'prise_en_charge',
      title: 'Prise en charge du produit',
      message: "<%= company.name %> - Bonjour <%= client.full_name %>.\n"\
                "Votre <%= client.product_full_name %> est pris en charge.\n"\
                "Vous serez tenu informé de l'évolution de la réparation.\n"\
                "MESSAGE AUTOMATIQUE. MERCI DE NE PAS REPONDRE.",
      user: user,
      company: company
    })
  end

  def self.product_states_list
    ["excellent", "bon", "moyen", "mauvais"]
  end
end

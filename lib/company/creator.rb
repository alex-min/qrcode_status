class Company::Creator
  def self.assign(user, params)
    ActiveRecord::Base.transaction do
      company = Company.create!(params.merge(users: [user]))
      company.product_states.create!(product_states_list.map { |name| { name: name } })
      company
    end
  end

  private

  def self.product_states_list
    ["excellent", "bon", "moyen", "mauvais"]
  end
end

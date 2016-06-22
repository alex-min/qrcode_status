puts "[Product States]"

company = User.find_by(email: ENV['ADMIN_EMAIL']).company

def create_product_states(company)
  ['excellent', 'bon', 'moyen', 'mauvais'].each do |product_state|
    if ProductState.find_by(legacy_slug: product_state, company: company).present?
      puts "[~] ProductState #{product_state} already created..."
    else
      ProductState.create!(legacy_slug: product_state,
                           name: product_state,
                           company: company)
      puts "[+] ProductState #{product_state} created"
    end
  end
end

default_company_name = I18n.t('default_company_name')
create_product_states(company)
create_product_states(Company.find_by(name: default_company_name))

puts ""

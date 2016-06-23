puts "[product types]"

admin_user = User.find_by(email: ENV['ADMIN_EMAIL'])

def create_product_types(company)
  [
    { name: 'Tour de PC', legacy_slug: 'tour_pc'},
    { name: 'Smartphone', legacy_slug: 'smartphone'},
    { name: 'PC Portable', legacy_slug: 'pc_portable'},
    { name: 'Tablette', legacy_slug: 'Tablette'},
    { name: 'Autre', legacy_slug: 'autre'}
  ].each do |product_type|
    if ProductType.find_by(name: product_type[:name], company: company).present?
      puts "[~] ProductType #{product_type[:name]} already created..."
    else
      ProductType.create!(product_type.merge(company: company, enabled: true))
      puts "[+] ProductType #{product_type[:name]} created"
    end
  end
end

default_company_name = I18n.t('default_company_name')

create_product_types(admin_user.company)
create_product_types(Company.find_by(name: default_company_name))

puts ""

puts "[companies]"

admin_user = User.find_by(email: ENV['ADMIN_EMAIL'])
if not admin_user.company.present?
  # :nocov:
  c = Company.new(name: 'Microdeo')
  c.users.push(admin_user)
  admin_user.company = c
  admin_user.save!
  c.save!
  puts "[+] Created company Microdeo"
  # :nocov:
else
  puts "[~] Admin company already exists, passing..."
end
company = admin_user.company
if company.website.blank?
  company.website = 'https://microdeo.com'
  company.save!
end
if company.phone.blank?
  company.phone = '0967500642'
  company.siret = '80065322200011'
  company.address = "27 rue Stanislas\n88100 Saint Dié des Vosges"
  company.save!
end

default_company_name = I18n.t('default_company_name')
if not Company.find_by(name: default_company_name)
  Company.create!(name: default_company_name,
                  website: 'https://example.org',
                  siret: '0123456789',
                  address: '10 Rue des Jardiniers, 88430 Corcieux',
                  demo: true)
  puts "[+] #{default_company_name} created"
end

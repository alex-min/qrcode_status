puts "[companies]"

admin_user = User.find_by(email: ENV['ADMIN_EMAIL'])
if not admin_user.company.present?
  # :nocov:
  c = Company.new(name: 'Microdeo',
                  siret: '80065322200011',
                  phone: '0967500642',
                  address: "27 rue Stanislas\n88100 Saint Dié des Vosges",
                  website: 'https://microdeo.com')
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

default_company_name = I18n.t('default_company_name')
default_company = Company.find_by(name: default_company_name)
unless default_company.present?
  Company.create!(name: default_company_name,
                  website: 'https://example.org',
                  siret: '0123456789',
                  address: '10 Rue des Jardiniers, 88430 Corcieux',
                  demo: true,
                  phone: '0333333333')
  puts "[+] #{default_company_name} created"
end

if default_company.present? and not default_company.phone?
  default_company.phone = '0333333333'
  default_company.save!
end

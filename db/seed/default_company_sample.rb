puts "[default company sample]"

default_company_name = I18n.t('default_company_name')
default_company = Company.find_by(name: default_company_name)

if Client.where(company: default_company).count < 20
  create_list(:client, 10, company: default_company, demo: true)
  create_list(:client, 10, company: default_company, processed: true, demo: true)
  puts "[+] 20 sample clients created"
else
  puts "[-] At least 20 sample clients are already created"
end


puts ""

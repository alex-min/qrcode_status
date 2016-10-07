puts "[companies]"

def terms
  [
    'Art 1.2 - Avis de mise à disposition',
    'Ø Lorsque votre appareil est disponible, vous êtes prévenu par un SMS.',
    '1.3 - Conditions de dépôt des produits',
    'Ø Vous devez impérativement déposer le ou les produits accompagnés de tous ses accessoires d’origine.',
    'Ø Vous déclarez disposer des originaux des logiciels installés sur votre matériel et les avoir acquis licitement.',
    'Ø Il vous appartient préalablement au dépôt de votre matériel à notre SAV de sauvegarder l\'ensemble des données. MicoDeo ne saurait en aucune façon',
    'être tenu pour responsable de toute perte ou altération de données qui pourraient survenir.',
    'Ø Le dépôt nécessite impérativement la signature du bon de dépôt. Aucune prestation ne pourra débuter sans la signature de ce bon.',
    'Ø L\'acceptation par MON ENTREPRISE du matériel et ou l\'absence de mention de la part de MON ENTREPRISE sur l\'état de l\'appareil ne saurait lier MON ENTREPRISE tant que cette dernière n\'a pas procédé au diagnostic de l\'état de l\'appareil.',
    '1.4 - Conditions de retrait du matériel',
    'Ø L\'appareil réparé est restitué uniquement sur présentation du bon de dépôt initial accompagné de la facture originale d\'achat.',
    'Ø La restitution se fait après complet paiement du prix de la réparation, et restitution de l\'appareil de prêt le cas échéant.',
    'Ø Tout appareil non-repris dans un délai de trois mois après que le client y ait été invité par appel téléphonique par le SAV sera considéré comme abandonné et le SAV pourra en disposer de plein droit comme bon lui semble, y compris en procédant à sa destruction.',
    '1.5 - Garantie des réparations et matériels',
    'Ø La garantie de MON ENTREPRISE couvre exclusivement les pièces et la main-d’œuvre à l\'exclusion de tout autre préjudice'
  ].join("\n")
end

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
                  phone: '0333333333',
                  terms: terms)
  puts "[+] #{default_company_name} created"
end

if default_company.present? and not default_company.phone?
  default_company.phone = '0333333333'
  default_company.save!
end

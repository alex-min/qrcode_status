puts "[product types]"

admin_user = User.find_by(email: ENV['ADMIN_EMAIL'])
company = admin_user.company

[
  { name: 'Tour de PC', legacy_slug: 'tour_pc'},
  { name: 'Smartphone', legacy_slug: 'smartphone'},
  { name: 'PC Portable', legacy_slug: 'pc_portable'},
  { name: 'Tablette', legacy_slug: 'Tablette'},
  { name: 'Autre', legacy_slug: 'autre'}
].each do |product_type|
  if ProductType.find_by(legacy_slug: product_type[:legacy_slug]).present?
    puts "[~] ProductType #{product_type[:name]} already created..."
  else
    ProductType.create!(product_type.merge(company: company, enabled: true))
    puts "[+] ProductType #{product_type[:name]} created"
  end
end

puts ""

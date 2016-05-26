puts "[Product States]"

company = User.find_by(email: ENV['ADMIN_EMAIL']).company

['excellent', 'bon', 'moyen', 'mauvais'].each do |product_state|
  if ProductState.find_by(legacy_slug: product_state).present?
    puts "[~] ProductState #{product_state} already created..."
  else
    ProductState.create!(legacy_slug: product_state,
                         name: product_state,
                         company: company)
    puts "[+] ProductState #{product_state} created"
  end
end

puts ""

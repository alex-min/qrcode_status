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
if admin_user.company.website.blank?
  admin_user.company.website = 'https://microdeo.com'
  admin_user.company.save!
end

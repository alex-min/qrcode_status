puts "[companies]"

admin_user = User.find_by(email: ENV['ADMIN_EMAIL'])
if not admin_user.company.present?
  c = Company.new(name: 'Microdeo')
  c.users.push(admin_user)
  admin_user.company = c
  admin_user.save!
  c.save!
  puts "[+] Created company Microdeo"
else
  puts "[~] Admin company already exists, passing..."
end

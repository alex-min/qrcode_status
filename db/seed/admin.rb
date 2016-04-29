puts "[admin user]"

def admin_user
  {
    email: ENV['ADMIN_EMAIL'],
    password: '12345678'
  }
end

if not User.find_by(email: admin_user[:email]).present?
  # :nocov:
  User.create!(admin_user)
  admin = User.find_by(email: ENV['ADMIN_EMAIL'])
  admin.encrypted_password = ENV['ADMIN_ENCRYPTED_PASSWORD']
  admin.save!
  puts "[+] Created admin user #{admin.email}"
  # :nocov:
else
  puts "[~] Admin user #{admin_user[:email]} already exists, passing..."
end

puts ""

puts "[admin user]"

def admin_user
  {
    email: ENV['ADMIN_EMAIL'],
    password: '11111111'
  }
end

if not User.find_by(email: admin_user[:email]).present?
  # :nocov:
  User.create!(admin_user)
  puts "[+] Created admin user #{admin_user[:email]}"
  # :nocov:
else
  puts "[~] Admin user #{admin_user[:email]} already exists, passing..."
end

puts ""

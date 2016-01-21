# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Client.create([
#                 {
#                   first_name: 'Anthony',
#                   last_name: 'MINETTE',
#                   address: '28 Le Chipal',
#                   postal_code: '88520',
#                   city: 'La Croix-Aux-Mines',
#                   phone: '0329517771',
#                   product: 'smartphone',
#                   brand: 'apple',
#                   product_name: 'iPhone 5',
#                   panne: "L'iphone marche plus vu qu'il est tombé par terre.",
#                   product_state: 'bon'
#                 }
#               ]
#               );
User.create!([{
                email: ENV['ADMIN_EMAIL'],
                password: '12345678', # this is replaced just after
                twillo_account_sid: ENV['TWILLO_ACCOUNT_SID'],
                twillo_auth_token: ENV['TWILLO_AUTH_TOKEN'],
                twillo_root_phone: ENV['TWILLO_ROOT_PHONE']
}])
admin = User.find_by(email: ENV['ADMIN_EMAIL'])
admin.encrypted_password = ENV['ADMIN_ENCRYPTED_PASSWORD']
admin.save!

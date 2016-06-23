module DefaultLogin
  include Capybara::DSL

  def login_with_default_user
    visit '/users/sign_in'
    fill_in :user_email, with: 'contact@microdeo.com'
    fill_in :user_password, with: '11111111'
    click_button 'Connexion'
  end

  def signup_as_new_client
    visit new_user_registration_path
    fill_in :user_email, with: Faker::Internet.email
    click_button I18n.t('devise.registrations.new.sign_up_action')
  end
end

module DefaultLogin
  include Capybara::DSL

  def login_with_default_user
    visit '/users/sign_in'
    fill_in :user_email, with: 'contact@microdeo.com'
    fill_in :user_password, with: '11111111'
    click_button 'Connexion'
  end
end

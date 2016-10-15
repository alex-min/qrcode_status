module DefaultLogin
  include Capybara::DSL

  def login_with_default_user
    visit '/users/sign_in'
    fill_in :user_email, with: 'user@example.org'
    fill_in :user_password, with: '11111111'
    click_button 'Connexion'
  end

  def signup_as_new_client
    visit new_user_registration_path
    fill_in :user_email, with: Faker::Internet.email
    click_button I18n.t('devise.registrations.new.sign_up_action')
  end

  def signup_as_new_client_with_company
    signup_as_new_client
    assign_new_company
  end

  def assign_new_company
    visit companies_assign_path
    company = build(:company)
    fill_in :company_name, with: company.name
    fill_in :company_website, with: company.website
    fill_in :company_address, with: company.address
    fill_in :company_siret, with: company.siret
    fill_in :company_phone, with: company.phone
    click_button I18n.t('companies.assign.add')
  end

  def makes_no_calls_to_the_sms_gateway
    assert_requested :post, %r{api.twilio.com}, times: 0
  end

  def makes_one_call_to_the_sms_gateway
    assert_requested :post, %r{api.twilio.com}, times: 1
  end
end

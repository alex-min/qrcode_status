feature 'Sign Up' do
  scenario 'Sign Up as a new Client' do
    when_i_sign_up_as_a_new_client
    then_i_should_have_demo_data
  end

  private

  def when_i_sign_up_as_a_new_client
    visit new_user_registration_path
    fill_in :user_email, with: sample_email
    click_button I18n.t('devise.registrations.new.sign_up_action')
  end

  def then_i_should_have_demo_data
    expect(page).to have_selector('.client', count: 20)
  end

  let(:sample_email) { Faker::Internet.email }
end

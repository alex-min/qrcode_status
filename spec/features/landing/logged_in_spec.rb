feature 'Logged in while visiting landing page' do
  before(:each) { login_with_default_user }

  scenario 'Logged in' do
    when_i_am_logged_in_on_landing_page
    then_i_get_redirected_to_the_app
  end

  def when_i_am_logged_in_on_landing_page
    visit landing_path
  end

  def then_i_get_redirected_to_the_app
    expect(current_path).to eq(clients_path)
  end
end

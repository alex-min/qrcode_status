feature 'Not logged in while visiting landing page' do
  scenario 'Not Logged in' do
    when_i_am_not_logged_in_on_landing_page
    then_i_get_the_landing_page
  end

  def when_i_am_not_logged_in_on_landing_page
    visit landing_path
  end

  def then_i_get_the_landing_page
    expect(current_path).to eq(landing_path)
  end
end

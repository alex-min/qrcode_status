feature 'User message' do
  before(:each) { login_with_default_user }

  scenario 'Visit list' do
    when_i_visit_the_list_of_message
    then_i_should_have_a_list_displayed
  end

  def when_i_visit_the_list_of_message
    visit user_messages_path
  end

  def then_i_should_have_a_list_displayed
    user_message_count = UserMessage.where(company: Company.first).count
    expect(page).to have_selector('.user-message', count: user_message_count)
  end
end

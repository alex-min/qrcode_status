feature 'User message' do
  scenario 'Visit list' do
    when_i_visit_the_list_of_message
    then_i_should_have_a_list_displayed
  end

  def when_i_visit_the_list_of_message
    visit user_messages_path
  end

  def then_i_should_have_a_list_displayed
    expect(page).to have_selector('.user-message', count: UserMessage.count)
  end
end

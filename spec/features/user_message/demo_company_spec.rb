feature 'User message for demo company' do
  scenario 'Visit list' do
    when_i_visit_the_list_of_message
    then_i_should_have_a_list_displayed
  end

  def when_i_visit_the_list_of_message
    signup_as_new_client
    visit user_messages_path
  end

  def then_i_should_have_a_list_displayed
    user_message_count = UserMessage.where(company: demo_company).count
    expect(page).to have_selector('.user-message', count: user_message_count)
  end

  private

  let(:demo_company) { Company.where(demo: true).first }
end

feature 'Client List' do
  before(:each) { login_with_default_user }

  scenario 'Empty list' do
    when_i_visit_the_clients_page_without_clients
    then_i_should_have_a_message_displayed
  end

  def when_i_visit_the_clients_page_without_clients
    visit clients_path
  end

  def then_i_should_have_a_message_displayed
    expect(body).to include(I18n.t('client.index.no_clients_to_display'))
  end
end

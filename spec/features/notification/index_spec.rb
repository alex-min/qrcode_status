feature 'Notifications Index' do
  before(:each) { login_with_default_user }

  scenario 'Look at list' do
    when_i_visit_the_notifications_page_with_a_list_of_notifications
    then_i_see_the_notifications
  end

  def when_i_visit_the_notifications_page_with_a_list_of_notifications
    create_client_events
    visit notifications_path
  end

  def then_i_see_the_notifications
    expect(page).to have_selector('.user-notification', count: 4)
  end

  private

  let(:create_client_events) { create_list(:client, 4) }
end

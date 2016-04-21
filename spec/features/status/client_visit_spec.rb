feature 'Visiting status as a client' do
  scenario 'Visiting status' do
    when_i_visit_the_status_of_an_existing_client
    then_i_should_see_its_status
  end

  def when_i_visit_the_status_of_an_existing_client
    allow_any_instance_of(StatusController).to receive(:current_user).and_return(nil)
    visit status_path(client.unique_id)
  end

  def then_i_should_see_its_status
    expect(page).to have_selector('.event-name', count: client.client_events.count)
  end

  let(:client) { create(:client) }
end

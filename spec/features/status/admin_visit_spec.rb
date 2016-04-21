feature 'Visiting status as a admin' do
  scenario 'Visiting status' do
    when_i_visit_the_status_of_an_existing_client
    then_i_should_be_redirected
  end

  def when_i_visit_the_status_of_an_existing_client
    allow_any_instance_of(StatusController).to receive(:current_user).and_return(User.first)
    visit status_path(client.unique_id)
  end

  def then_i_should_be_redirected
    expect(page).to have_selector('#new_client_event')
  end

  let(:client) { create(:client) }
end

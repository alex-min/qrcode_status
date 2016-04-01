feature 'Listing Clients' do
  scenario 'Listing Clients' do
    when_i_have_a_list_of_clients
    then_i_should_arrive_on_the_status_page_with_clients
  end

  def when_i_have_a_list_of_clients
    clients
    visit clients_path
  end

  def then_i_should_arrive_on_the_status_page_with_clients
    expect(body).to include('Liste des clients')
    expect(page).to have_selector('.client', count: 5)
  end

  let(:clients) { create_list(:client, 5) }
end

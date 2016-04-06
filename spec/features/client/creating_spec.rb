feature 'Creating Client' do
  scenario 'Creating a new client' do
    when_i_create_a_new_client_from_the_form
    then_a_new_client_is_created
  end

  scenario 'Creating a new client with invalid phone' do
    when_i_create_a_new_client_from_the_form_with_invalid_phone
    then_i_should_have_an_error_message
  end

  def when_i_create_a_new_client_from_the_form
    visit client_new_path
    fill_client_form(client)
    VCR.use_cassette(:sms_success, :match_requests_on => [:host, :method]) do
      click_button 'Ajouter le client'
    end
  end

  def then_a_new_client_is_created
    visit clients_path
    expect(page).to have_selector('.client', count: 1)
  end

  def when_i_create_a_new_client_from_the_form_with_invalid_phone
    visit client_new_path
    fill_client_form(client_with_invalid_phone)
    VCR.use_cassette(:sms_failure_invalid_phone,
      :match_requests_on => [:host, :method]) do
        click_button 'Ajouter le client'
    end
  end

  def then_i_should_have_an_error_message
    expect(page).to have_selector('.notification-error', count: 1)
  end

  private

  def fill_client_form(client)
    fill_in :client_first_name, with: client.first_name
    fill_in :client_last_name, with: client.last_name
    fill_in :client_address, with: client.address
    fill_in :client_postal_code, with: client.postal_code
    fill_in :client_city, with: client.city
    fill_in :client_phone, with: client.phone
  end

  let(:client) { build(:client) }
  let(:client_with_invalid_phone) { build(:client, :with_invalid_phone) }
end

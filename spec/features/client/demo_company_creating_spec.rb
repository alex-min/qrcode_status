feature 'Creating Client with demo account' do
  before(:each) { signup_as_new_client }

  scenario 'Creating a new client' do
    when_i_create_a_new_client_from_the_form
    then_a_new_client_is_created
  end

  def when_i_create_a_new_client_from_the_form
    visit_and_fill_client_form(client)
    click_add_button(:sms_success)
    no_sms_api_call_is_done
  end

  def then_a_new_client_is_created
    visit clients_path
    expect(page).to have_selector('.client', count: 21)
    expect(body).to include(I18n.t('client.index.welcome_default_account'))
    expect(Client.last.demo).to eq(true)
  end

  private

  def no_sms_api_call_is_done
    assert_requested :post, %r{https://.*:.*@api.twilio.com/.*/Messages.json}, times: 0
  end

  def visit_and_fill_client_form(client)
    visit client_new_path
    fill_in :client_first_name, with: client.first_name
    fill_in :client_last_name, with: client.last_name
    fill_in :client_address, with: client.address
    fill_in :client_postal_code, with: client.postal_code
    fill_in :client_city, with: client.city
    fill_in :client_phone, with: client.phone
    first(:css, "#client_product option[value='Smartphone']").select_option
    first(:css, '#client_product_state_id'\
                " option[value='#{client.product_state.id}']").select_option
    fill_in :client_brand, with: client.brand
    fill_in :client_product_name, with: client.product_name
  end

  def click_add_button(cassette_name)
    VCR.use_cassette(cassette_name, :match_requests_on => [:host, :method]) do
      click_button 'Ajouter le client'
    end
  end

  let(:client) { build(:client, company: demo_company) }

  let(:demo_company) { Company.find_by!(demo: true) }
end

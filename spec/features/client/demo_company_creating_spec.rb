RSpec.feature 'Creating Client with demo account' do
  before(:each) do
    signup_as_new_client
    visit_and_fill_client_form(client)
    click_add_button(gateway_result)
    visit clients_path
  end

  let(:gateway_result) { :sms_success }
  let(:client) { build(:client, company: demo_company) }
  let(:demo_company) { Company.find_by!(demo: true) }

  context 'when creating a new client' do
    it { makes_no_calls_to_the_sms_gateway }
    it { expect(page).to have_selector('.client', count: 21) }
    it { expect(body).to include(I18n.t('client.index.welcome_default_account')) }
    it { expect(Client.last.demo).to eq(true) }
  end

  private

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
end

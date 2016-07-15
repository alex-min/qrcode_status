feature 'Creating Client' do
  before(:each) { login_with_default_user }

  scenario 'Creating a new client' do
    when_i_create_a_new_client_from_the_form
    then_a_new_client_is_created
  end

  scenario 'Creating a new client with unformated phone number' do
    when_i_create_a_new_client_with_unformated_phone_from_the_form
    then_a_new_client_is_created_with_formated_phone
  end

  scenario 'Creating a new client with invalid phone' do
    when_i_create_a_new_client_from_the_form_with_invalid_phone
    then_i_should_have_an_error_message
  end

  scenario 'Creating a new client with failed sms' do
    when_i_create_a_new_client_from_the_form_with_failed_sms
    then_i_should_have_an_error_message_for_failed_sms
  end

  scenario 'Creating a new client with landline phone' do
    when_i_create_a_new_client_with_landline_phone
    then_i_should_not_try_to_send_a_sms
  end

  scenario 'Creating a new client without phone' do
    when_i_create_a_new_client_without_phone
    then_a_new_client_is_created
  end

  def when_i_create_a_new_client_from_the_form
    visit_and_fill_client_form(client)
    click_add_button(:sms_success)
    except_sms_api_call
  end

  def then_a_new_client_is_created
    visit clients_path
    expect(page).to have_selector('.client', count: 1)
    and_message_sent_is_a_welcome_message
    db_client = Client.last
    expect(ClientEvent.last.sms_sent).to eq(true)
    expect(db_client.company.id).to eq(db_client.user.company.id)
    expect(db_client.product_state.name).to eq(client.product_state.name)
  end

  def and_message_sent_is_a_welcome_message
    event = ClientEvent.last
    expect(event.message).to eq(prise_en_charge_message(event.client))
  end

  def when_i_create_a_new_client_from_the_form_with_invalid_phone
    visit_and_fill_client_form(client_with_invalid_phone)
    click_add_button(:sms_success)
    except_no_sms_api_call
  end

  def then_i_should_have_an_error_message
    expect(page).to have_selector('.help-block', count: 1)
    phone_validation_error_is_present
  end

  def when_i_create_a_new_client_from_the_form_with_failed_sms
    visit client_new_path
    visit_and_fill_client_form(client)
    click_add_button(:sms_failure_invalid_phone)
    except_sms_api_call
  end

  def then_i_should_have_an_error_message_for_failed_sms
    expect(page).to have_selector('.notification-error', count: 1)
    expect(page.first('.notification-error').text).to eq(I18n.t('errors.messages.sms', phone: client.phone))
  end

  def when_i_create_a_new_client_with_landline_phone
    visit_and_fill_client_form(client_with_landline)
    click_add_button(:sms_success)
    except_no_sms_api_call
  end

  def then_i_should_not_try_to_send_a_sms
  end

  def when_i_create_a_new_client_with_unformated_phone_from_the_form
    visit_and_fill_client_form(client_with_unformated_phone)
    click_add_button(:sms_success)
    except_sms_api_call
  end

  def then_a_new_client_is_created_with_formated_phone
    visit client_edit_path(Client.last.unique_id)
    formated_phone = '06 11 11 11 11'
    expect(first('#client_phone').value).to eq(formated_phone)
  end

  def when_i_create_a_new_client_without_phone
    visit_and_fill_client_form(client_without_phone)
    click_add_button(:sms_success)
    except_no_sms_api_call
  end

  private

  def except_no_sms_api_call
    assert_requested :post, %r{api.twilio.com}, times: 0
  end

  def except_sms_api_call
    assert_requested :post, %r{api.twilio.com}, times: 1
  end

  def click_add_button(cassette_name)
    VCR.use_cassette(cassette_name, :match_requests_on => [:host, :method]) do
      click_button 'Ajouter le client'
    end
  end

  def phone_validation_error_is_present
    phone_error_message = I18n.t('activerecord.errors.models.client.attributes.phone.invalid')
    expect(first('.help-block').text).to include(phone_error_message)
  end

  def visit_and_fill_client_form(client)
    visit client_new_path
    fill_in :client_first_name, with: client.first_name
    fill_in :client_last_name, with: client.last_name
    fill_in :client_address, with: client.address
    fill_in :client_postal_code, with: client.postal_code
    fill_in :client_city, with: client.city
    fill_in :client_phone, with: client.phone
    first(:css, "#client_product option[value='#{client.product}']").select_option
    first(:css, '#client_product_state_id'\
                " option[value='#{client.product_state.id}']").select_option
    fill_in :client_brand, with: client.brand
    fill_in :client_product_name, with: client.product_name
  end

  let(:client) { build(:client, product: 'Smartphone') }
  let(:client_with_unformated_phone) { build(:client, :with_unformated_phone, product: 'Smartphone') }
  let(:client_with_landline) { create(:client, :with_landline, product: 'Smartphone') }
  let(:client_without_phone) { build(:client, :without_phone, product: 'Smartphone') }
  let(:create_client) { client }
  let(:client_with_invalid_phone) { build(:client, :with_invalid_phone, product: 'Smartphone') }

  def prise_en_charge_message(client)
    "Microdeo - Bonjour #{client.full_name}.\n"\
    "Votre smartphone Apple Iphone est pris en charge.\n"\
    "Vous serez tenu informé de l'évolution de la réparation.\n\n"\
    "MESSAGE AUTOMATIQUE. MERCI DE NE PAS REPONDRE."
  end
end

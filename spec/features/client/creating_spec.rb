feature 'Creating Client' do
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
    and_message_sent_is_the_one_expected
    expect(ClientEvent.last.sms_sent).to eq(true)
  end

  def and_message_sent_is_the_one_expected
    expect(ClientEvent.last.message).to eq(prise_en_charge_message)
  end

  def when_i_create_a_new_client_from_the_form_with_invalid_phone
    visit client_new_path
    fill_client_form(client_with_invalid_phone)
    VCR.use_cassette(:sms_success,
      :match_requests_on => [:host, :method]) do
        click_button 'Ajouter le client'
    end
  end

  def then_i_should_have_an_error_message
    expect(page).to have_selector('.notification-error', count: 1)
    phone_validation_error_is_present
  end

  def when_i_create_a_new_client_from_the_form_with_failed_sms
    visit client_new_path
    fill_client_form(client)
    VCR.use_cassette(:sms_failure_invalid_phone,
      :match_requests_on => [:host, :method]) do
        click_button 'Ajouter le client'
    end
  end

  def then_i_should_have_an_error_message_for_failed_sms
    expect(page).to have_selector('.notification-error', count: 1)
    expect(page.first('.notification-error').text).to eq(I18n.t('errors.messages.sms', phone: client.phone))
  end

  def when_i_create_a_new_client_with_landline_phone
    visit client_new_path
    fill_client_form(client_with_landline)
  end

  def then_i_should_not_try_to_send_a_sms
  end

  def when_i_create_a_new_client_with_unformated_phone_from_the_form
    visit client_new_path
    fill_client_form(client_with_unformated_phone)
    VCR.use_cassette(:sms_success, :match_requests_on => [:host, :method]) do
      click_button 'Ajouter le client'
    end
  end

  def then_a_new_client_is_created_with_formated_phone
    visit client_edit_path(Client.last.unique_id)
    formated_phone = '06 11 11 11 11'
    expect(first('#client_phone').value).to eq(formated_phone)
  end

  private

  def phone_validation_error_is_present
    phone_error_message = I18n.t('activerecord.attributes.client.phone')
    expect(page.first('.notification-error').text).to include(phone_error_message)
  end

  def fill_client_form(client)
    fill_in :client_first_name, with: client.first_name
    fill_in :client_last_name, with: client.last_name
    fill_in :client_address, with: client.address
    fill_in :client_postal_code, with: client.postal_code
    fill_in :client_city, with: client.city
    fill_in :client_phone, with: client.phone
    first(:css, "#client_product option[value='#{client.product}']").select_option
    first(:css, '#client_product_state'\
                " option[value='#{client.product_state}']").select_option
    fill_in :client_brand, with: client.brand
    fill_in :client_product_name, with: client.product_name
  end

  let(:client) { build(:client) }
  let(:client_with_unformated_phone) { build(:client, :with_unformated_phone) }
  let(:client_with_landline) { create(:client, :with_landline) }
  let(:create_client) { client }
  let(:client_with_invalid_phone) { build(:client, :with_invalid_phone) }

  let(:prise_en_charge_message) do
    client = create_client
    ERB.new(UserMessage.where(code: :prise_en_charge).first.message).result(binding)
  end
end

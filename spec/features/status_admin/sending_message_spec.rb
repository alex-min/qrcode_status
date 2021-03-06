feature 'Sending message to client' do
  before(:each) { login_with_default_user }

  scenario 'Sending update message' do
    when_i_have_an_existing_client
    then_i_can_send_a_message_to_him
  end

  scenario 'Sending closing message' do
    when_i_have_an_existing_client
    then_i_can_send_a_message_to_close_the_ticket
  end

  def when_i_have_an_existing_client
    visit status_admin_path(client.unique_id)
  end

  def then_i_can_send_a_message_to_him
    expect(first('h2').text).to eq(I18n.t('app.messages.to_sent_to', name: client.full_name))
    user_message_count = UserMessage.where(company: client.company).count
    expect(page).to have_selector('.sms-message-type', count: user_message_count)
    messages.each do |message|
      body_text = find("#client_event_event_name_#{message.code}").find(:xpath, '..').text
      expect(body_text).to eq(message.title)
    end
    choose("client_event_event_name_#{test_message}")
    VCR.use_cassette(:sms_success, :match_requests_on => [:host, :method]) do
      click_button 'Ajouter le message'
    end
    expect(ClientEvent.last.message).to eq(prise_en_charge_message)
    expect(ClientEvent.last.sms_sent).to eq(true)
    expect(first('.event-name').text).to eq(prise_en_charge_title)
  end

  def then_i_can_send_a_message_to_close_the_ticket
    choose("client_event_event_name_#{close_ticket_message.code}")
    VCR.use_cassette(:sms_success, :match_requests_on => [:host, :method]) do
      click_button 'Ajouter le message'
    end
    expect(client.reload.processed).to eq(true)
    no_action_should_be_available
  end

  def no_action_should_be_available
    visit status_admin_path(client.unique_id)
    expect(page).to have_selector('.sms-message-type', count: 0)
  end

  let(:messages) { UserMessage.all }
  let(:close_ticket_message) { UserMessage.where(action: :close_ticket).first }
  let(:test_message) { 'repair_in_progress' }
  let(:client) { create(:client, product: 'smartphone') }
  let(:create_client) { client }
  let(:prise_en_charge_title) do
    UserMessage.where(code: test_message).first.title
  end
  let(:prise_en_charge_message) do
    "Microdeo - Bonjour #{create_client.full_name}.\n"\
    "Votre smartphone Apple Iphone est en cours de réparation, "\
    "nous vous tiendrons informés de l'avancement de la réparation.\n\n"\
    "MESSAGE AUTOMATIQUE. MERCI DE NE PAS REPONDRE."
  end
end

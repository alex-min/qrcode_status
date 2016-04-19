feature 'Sending message to client' do
  scenario 'Sending update message' do
    when_i_have_an_existing_client
    then_i_can_send_a_message_to_him
  end

  def when_i_have_an_existing_client
    visit status_admin_path(client.unique_id)
  end

  def then_i_can_send_a_message_to_him
    expect(first('h2').text).to eq(I18n.t('app.messages.to_sent_to', name: client.full_name))
    expect(page).to have_selector('.sms-message-type', count: UserMessage.count)
    messages.each do |message|
      body_text = find("#client_event_event_name_#{message.code}").find(:xpath, '..').text
      expect(body_text).to eq(message.title)
    end
    choose("client_event_event_name_#{test_message}")
    VCR.use_cassette(:sms_success, :match_requests_on => [:host, :method]) do
      click_button 'Ajouter le message'
    end
    expect(ClientEvent.last.message).to eq(prise_en_charge_message)
  end

  let(:messages) { UserMessage.all }
  let(:test_message) { 'repair_in_progress' }
  let(:client) { create(:client) }
  let(:create_client) { client }
  let(:prise_en_charge_message) do
    client = create_client
    ERB.new(UserMessage.where(code: test_message).first.message).result(binding)
  end
end

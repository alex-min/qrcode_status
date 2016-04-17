feature 'Sending message to client' do
  scenario 'Sending update message' do
    when_i_have_an_existing_client
    then_i_can_send_a_message_to_him
  end

  def when_i_have_an_existing_client
    visit status_admin_path(client.unique_id)
    expect(first('h2').text).to eq(I18n.t('app.messages.to_sent_to', name: client.full_name))
  end

  def then_i_can_send_a_message_to_him
  end

  let(:client) { create(:client) }
end

feature 'Mark as done' do
  scenario 'Marking a client as done without notification' do
    when_i_mark_a_client_as_done_without_notification
    then_the_client_is_done_without_notification
  end

  scenario 'Marking a client as done with notification' do
    when_i_mark_a_client_as_done_with_notification
    then_the_client_is_done_with_notification
  end

  scenario 'Marking a client as done with failed sms' do
    when_i_mark_a_client_as_done_with_notification_with_failed_sms
    then_the_client_should_stay_the_same
  end

  def when_i_mark_a_client_as_done_without_notification
    visit client_mark_as_done_path(client.id)
    click_button I18n.t('app.client.mark_as_done_no_notification')
  end

  def then_the_client_is_done_without_notification
    expect(client.client_events.count).to eq(1)
  end


  def when_i_mark_a_client_as_done_with_notification
    visit client_mark_as_done_path(client.id)
    VCR.use_cassette(:sms_success, :match_requests_on => [:host, :method]) do
      click_button I18n.t('app.client.mark_as_done_notification')
    end
  end

  def then_the_client_is_done_with_notification
    expect(client.client_events.count).to eq(2)
  end

  def when_i_mark_a_client_as_done_with_notification_with_failed_sms
    visit client_mark_as_done_path(client.id)
    VCR.use_cassette(:sms_failure_invalid_phone, :match_requests_on => [:host, :method]) do
      click_button I18n.t('app.client.mark_as_done_notification')
    end
  end

  def then_the_client_should_stay_the_same
    expect(page).to have_selector('.notification-error', count: 1)
    expect(Client.last.processed).to eq(false)
  end

  private

  let(:client) { create(:client) }
end

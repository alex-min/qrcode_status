RSpec.feature 'Mark as done' do
  around(:each) do |example|
    VCR.use_cassette(gateway_result, :match_requests_on => [:host, :method]) do
      login_with_default_user
      visit client_mark_as_done_path(client.id)
      click_button I18n.t(button_to_click)
      example.run
    end
  end

  let(:client) { create(:client) }
  let(:send_notification_button) { 'app.client.mark_as_done_notification' }
  let(:no_notification_button) { 'app.client.mark_as_done_no_notification' }
  let(:client_events_count) { client.reload.client_events.count }
  let(:client_processed?) { client.reload.processed }
  let(:gateway_result) { :sms_success }

  context 'Marking a client as done without notification' do
    let(:button_to_click) { no_notification_button }
    it { makes_no_calls_to_the_sms_gateway }
    it { expect(client_processed?).to eq(true) }
    it { expect(client_events_count).to eq(1) }
  end

  context 'Marking a client as done with notification' do
    let(:button_to_click) { send_notification_button }
    it { makes_one_call_to_the_sms_gateway }
    it { expect(client_processed?).to eq(true) }
    it { expect(client_events_count).to eq(2) }
  end

  context 'Marking a client as done with failed sms' do
    let(:gateway_result) { :sms_failure_invalid_phone }
    let(:button_to_click) { send_notification_button }
    it { makes_one_call_to_the_sms_gateway }
    it 'displays a notification error' do
      expect(page).to have_selector('.notification-error', count: 1)
    end
    it { expect(client_processed?).to eq(false) }
    it { expect(client_events_count).to eq(1) }
  end
end

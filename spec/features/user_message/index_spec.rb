RSpec.feature 'User message' do
  before do
    login_with_default_user
    visit user_messages_path
  end

  let(:user_message_count) { UserMessage.where(company: Company.first).count }

  context 'Visit list with a default user should have a default list' do
    it { expect(user_message_count).not_to eq(0) }
    it { expect(page).to have_selector('.user-message', count: user_message_count) }
  end
end

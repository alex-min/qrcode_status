RSpec.feature 'Client List' do
  before(:each) do
    login_with_default_user
    visit clients_path
  end

  subject { page.body }

  context 'no clients in the list' do
    it 'must display an help message to say there is no clients' do
      is_expected.to include(I18n.t('client.index.no_clients_to_display'))
    end
  end
end

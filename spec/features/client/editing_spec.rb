RSpec.feature 'Editing Client' do
  before(:each) do
    login_with_default_user
    create_client
    visit client_edit_path(client.unique_id)
  end

  let(:new_address) { 'New address after edition' }
  let(:submit_button) { first("input[type='submit']") }
  let(:create_client) { create(:client) }
  let(:client) { create_client }

  subject { page.find_by_id(:client_address).value }

  context 'without editing the client' do
    it 'should have the same address' do
      is_expected.to eq(client.address)
    end
  end

  context 'after editing the client' do
    before do
      fill_in :client_address, with: new_address
      submit_button.click
    end
    it 'should have changed the address' do
      is_expected.to eq(new_address)
    end
  end
end

RSpec.feature 'view client' do
  before(:each) do
    signup_as_new_client
    visit clients_path
    visit first('.client-view-link')['href']
  end

  context 'with default company' do
    subject { first('object') }

    it { expect(subject[:type]).to eq('application/pdf') }
    it { expect(subject[:data]).to eq('view.pdf') }
    it { expect(subject.first('a')[:href]).to eq('view.pdf') }
  end
end

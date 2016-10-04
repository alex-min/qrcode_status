RSpec.feature 'Creating Client with new company' do
  before(:each) { signup_as_new_client_with_company }

  subject { page }

  context "When I create a new company" do
    it "has no clients" do
      is_expected.to have_selector('.client', count: 0)
    end
  end
end

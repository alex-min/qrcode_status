RSpec.feature 'Assing a company to the user' do
  before(:each) do
    login
    visit companies_assign_path
  end

  let(:company) { build(:company) }
  let(:click_submit_button) { click_button I18n.t('companies.assign.add') }
  let(:company_logo_src) { first('.company-logo')['src'] }
  let(:avatar) do
    visit company_logo_src
    expect(page.status_code).to eq(200)
    file = Tempfile.new('test_company_logo')
    file.write(body.force_encoding("UTF-8"))
    file.close
    FastImage.new(file.path)
  end
  let(:submit_company_form_with_empty_data) do
    submit_company_form(name: '', website: '', address: '', siret: '', phone: '')
  end
  let(:submit_company_form_with_company_data) do
    submit_company_form(name:     company.name,
                        website:  company.website,
                        address:  company.address,
                        siret:    company.siret,
                        phone:    company.phone)
  end
  let(:company_top_left_name) { first('.company-name').text }

  context 'The User already has a company and tries to create one' do
    let(:login) { login_with_default_user }
    it "redirects to the client page" do
      expect(current_path).to eq(clients_path)
    end
  end

  context 'The User has a demo company' do
    let(:login) { signup_as_new_client }
    it { expect(current_path).to eq(companies_assign_path) }
    it { expect(body).to include(I18n.t('companies.assign.add')) }
    context 'has a blank avatar' do
      it { expect(avatar.type).to eq(:png) }
      it { expect(avatar.size).to eq([30, 30]) }
    end
  end

  context 'trying to fill a company without data' do
    let(:login) { signup_as_new_client }
    before { submit_company_form_with_empty_data }
    context 'errors are displayed for requried fields' do
      it { expect(page).to have_selector('.help-block', count: 4) }
      it { expect(current_path).to eq(companies_assign_path) }
    end
  end

  context 'register a company' do
    let(:login) { signup_as_new_client }
    before { submit_company_form_with_company_data }
    context 'a new company should be assigned' do
      it { expect(current_path).to eq(clients_path) }
      it { expect(company_top_left_name).to eq(company.name) }
      it "has no client" do
        expect(page).to have_selector('.client', count: 0)
      end
      it "says there is no clients to display" do
        expect(body).to include(I18n.t('client.index.no_clients_to_display'))
      end
    end
  end

  private

  def submit_company_form(name:, website:, address:, siret:, phone:)
    fill_in :company_name, with: name
    fill_in :company_website, with: website
    fill_in :company_address, with: address
    fill_in :company_siret, with: siret
    fill_in :company_phone, with: phone
    click_submit_button
  end
end

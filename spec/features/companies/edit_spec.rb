RSpec.feature 'Edit companies' do
  before(:each) do
    login
    visit company_edit_path
    fill_company_fields
  end

  let(:fixture_logo) { Rails.root.join('spec/fixtures/files/1x1.jpg') }
  let(:sample_name) { Faker::Name.name }
  let(:sample_siret) { Faker::Name.name }
  let(:sample_website) { "https://#{Faker::Internet.domain_name}" }
  let(:sample_phone) { Faker::PhoneNumber.phone_number }
  let(:click_submit_button) { click_button I18n.t('companies.company_form.edit', company_name: Company.first.name) }

  let(:name) { nil }
  let(:siret) { nil }
  let(:website) { nil }
  let(:phone) { nil }

  let(:fill_company_fields) do
    fill_in :company_name, with: name
    fill_in :company_siret, with: siret
    fill_in :company_website, with: website
    fill_in :company_phone, with: phone
  end

  let(:company_logo) do
    visit first('.company-logo')['src']
    file = Tempfile.new('test_company_logo')
    file.write(body.force_encoding("UTF-8"))
    file.close
    image = FastImage.new(file.path)
    file.unlink
    image
  end

  context 'Edit default company' do
    let(:login) { signup_as_new_client }
    it { expect(current_path).to eq(companies_assign_path) }
  end

  context 'With an existing user' do
    let(:login) { login_with_default_user }
    context 'editing the company' do
      let(:name) { sample_name }
      let(:siret) { sample_siret }
      let(:website) { sample_website }
      let(:phone) { sample_phone }
      before { click_submit_button }

      it { expect(find_field(:company_name).value).to eq(sample_name) }
      it { expect(find_field(:company_siret).value).to eq(sample_siret) }
      it { expect(find_field(:company_website).value).to eq(sample_website) }
      it { expect(find_field(:company_phone).value).to eq(sample_phone) }
    end

    context 'uploadig a logo' do
       before do
        attach_file :company_logo, fixture_logo
        click_submit_button
       end

       it { expect(company_logo.type).to eq(:jpeg) }
       it { expect(company_logo.size).to eq([1, 1])}
    end

    context 'Required field' do
      let(:name) { '' }
      let(:siret) { '' }
      let(:website) { '' }
      let(:phone) { '' }
      before { click_submit_button }

      it { expect(page).to have_selector('.help-block', count: 3) }
      it { expect(current_path).to eq(company_edit_path) }
    end
  end
end

RSpec.feature 'exporting pdf' do
  before(:each) do
    signup_as_new_client
    visit clients_path
    visit "#{first('.client-view-link')['href']}.pdf"
  end

  let(:document) { PDF::Inspector::Page.analyze(body) }
  let(:first_page) { document.pages.first }
  let(:document_strings) { first_page[:strings] }
  let(:demo_company) { Company.find_by(demo: true) }
  let(:first_line_term) { demo_company.terms.split("\n")[0] }

  let(:title) { document_strings.first }
  let(:company) { document_strings.second }

  context 'with default company' do
    subject { document_strings }

    it { expect(document.pages.count).to eq(1) }
    it { expect(title).to eq(I18n.t('client.view.sav')) }
    it { expect(company).to eq(demo_company.name) }
    it "has the required pdf text" do
      is_expected.to include(I18n.t('client.view.broken_products_list'))
      is_expected.to include(I18n.t('client.view.product_state'))
      is_expected.to include(I18n.t('activerecord.attributes.client.brand'))
      is_expected.to include(I18n.t('activerecord.attributes.client.product_name'))
      expect(document_strings.join('')).to include(first_line_term)
    end
  end
end

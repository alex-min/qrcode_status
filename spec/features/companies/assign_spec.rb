feature 'Assing a company to the user' do
  scenario 'The User already has a company' do
    when_i_try_to_assign_a_company_while_the_user_has_a_company
    then_i_should_be_redirected_to_the_clients
  end

  scenario 'The User has a demo company' do
    when_i_try_to_assign_a_company
    then_a_new_company_should_be_assigned
  end

  scenario 'The demo company has a blank avatar' do
    when_i_have_a_demo_company
    then_i_have_a_blank_avatar
  end

  def when_i_have_a_demo_company
    signup_as_new_client
  end

  def then_i_have_a_blank_avatar
    visit first('.company-logo')['src']
    expect(page.status_code).to eq(200)
    file = Tempfile.new('test_company_logo')
    file.write(body.force_encoding("UTF-8"))
    file.close
    image = FastImage.new(file.path)
    expect(image.type).to eq(:png)
    expect(image.size).to eq([30, 30])
  end


  def when_i_try_to_assign_a_company_while_the_user_has_a_company
    login_with_default_user
    visit companies_assign_path
  end

  def then_i_should_be_redirected_to_the_clients
    expect(current_path).to eq(clients_path)
  end


  def when_i_try_to_assign_a_company
    signup_as_new_client
    visit companies_assign_path
    expect(current_path).to eq(companies_assign_path)
    expect(body).to include(I18n.t('companies.assign.add'))
    fill_company_form(company)
    click_button I18n.t('companies.assign.add')
  end

  def then_a_new_company_should_be_assigned
    expect(current_path).to eq(clients_path)
    expect(first('.company-name').text).to eq(company.name)
    expect(page).to have_selector('.client', count: 0)
    expect(body).to include(I18n.t('client.index.no_clients_to_display'))
  end

  private

  def fill_company_form(company)
    fill_in :company_name, with: company.name
    fill_in :company_website, with: company.website
    fill_in :company_address, with: company.address
    fill_in :company_siret, with: company.siret
    fill_in :company_phone, with: company.phone
  end

  let(:company) { build(:company)}
end

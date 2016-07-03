feature 'Edit companies' do
  scenario 'Edit default company' do
    when_i_try_to_edit_the_default_company
    then_i_get_redirected_to_assign_a_new_one
  end

  scenario 'Edit company' do
    when_i_edit_company
    then_it_gets_edited
  end

  scenario 'Logo upload' do
    when_i_upload_a_logo
    then_the_logo_is_displayed
  end

  scenario 'Required field' do
    when_i_try_to_add_empty_fields
    then_i_should_have_a_required_field_error
  end

  def when_i_try_to_add_empty_fields
    login_with_default_user
    visit company_edit_path
    fill_in :company_name, with: ''
    fill_in :company_siret, with: ''
    fill_in :company_website, with: ''
    fill_in :company_phone, with: ''
    click_submit_button
  end

  def then_i_should_have_a_required_field_error
    expect(page).to have_selector('.help-block', count: 3)
    expect(current_path).to eq(company_edit_path)
  end

  def when_i_upload_a_logo
    login_with_default_user
    visit company_edit_path
    attach_file :company_logo, fixture_logo
    click_submit_button
  end

  def then_the_logo_is_displayed
    visit first('.company-logo')['src']
    expect(page.status_code).to eq(200)
    file = Tempfile.new('test_company_logo')
    file.write(body.force_encoding("UTF-8"))
    file.close
    image = FastImage.new(file.path)
    expect(image.type).to eq(:jpeg)
    expect(image.size).to eq([1, 1])
    file.unlink
  end

  def when_i_try_to_edit_the_default_company
    signup_as_new_client
    visit company_edit_path
  end

  def then_i_get_redirected_to_assign_a_new_one
    expect(current_path).to eq(companies_assign_path)
  end

  def when_i_edit_company
    login_with_default_user
    visit company_edit_path
    fill_in :company_name, with: sample_text
    fill_in :company_siret, with: sample_text
    fill_in :company_website, with: sample_website
    fill_in :company_phone, with: sample_phone
    click_submit_button
  end

  def then_it_gets_edited
    expect(find_field(:company_name).value).to eq(sample_text)
    expect(find_field(:company_siret).value).to eq(sample_text)
    expect(find_field(:company_website).value).to eq(sample_website)
    expect(find_field(:company_phone).value).to eq(sample_phone)
  end

  private

  def click_submit_button
    click_button I18n.t('companies.company_form.edit', company_name: Company.first.name)
  end

  let(:fixture_logo) do
    Rails.root.join('spec/fixtures/files/1x1.jpg')
  end

  let(:sample_text) { Faker::Name.name }
  let(:sample_website) { "https://#{Faker::Internet.domain_name}" }
  let(:sample_phone) { Faker::PhoneNumber.phone_number }
end

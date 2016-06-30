feature 'Edit companies' do
  scenario 'Edit default company' do
    when_i_try_to_edit_the_default_company
    then_i_get_redirected_to_assign_a_new_one
  end

  def when_i_try_to_edit_the_default_company
    signup_as_new_client
    visit company_edit_path
  end

  def then_i_get_redirected_to_assign_a_new_one
    expect(current_path).to eq(companies_assign_path)
  end
end

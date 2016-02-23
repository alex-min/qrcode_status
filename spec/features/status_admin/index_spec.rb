feature 'Priority old allocations page' do
  scenario 'Login' do
    when_i_login_as_an_existing_user
    then_i_should_arrive_on_the_status_page
  end

  def when_i_login_as_an_existing_user
    visit clients_path
  end

  def then_i_should_arrive_on_the_status_page
    expect(body).to include('Liste des clients')
  end
end

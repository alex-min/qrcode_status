feature 'Editing Client' do
   before(:each) { login_with_default_user }

   scenario 'Editing an existing client' do
     when_i_edit_an_existing_client
     then_the_client_should_be_edited
   end

   def when_i_edit_an_existing_client
    visit client_edit_path(client.unique_id)
    expect(client_address_input_value).to eq(client.address)
    fill_in :client_address, with: new_address
    submit_button.click
   end

   def then_the_client_should_be_edited
    expect(client_address_input_value).to eq(new_address)
   end

   private

   let(:new_address) { 'New address after edition' }
   let(:submit_button) { first("input[type='submit']") }
   let(:client) { create(:client) }

   def client_address_input_value
    page.find_by_id(:client_address).value
   end
end

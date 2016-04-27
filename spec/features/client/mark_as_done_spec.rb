feature 'Mark as done' do
  scenario 'Marking a client as done without notification' do
    when_i_mark_a_client_as_done_without_notification
    then_the_client_is_done_without_notification
  end

  def when_i_mark_a_client_as_done_without_notification
    visit client_mark_as_done_path(client.id)
  end

  def then_the_client_is_done_without_notification
  end

  private

  let(:client) { create(:client) }
end

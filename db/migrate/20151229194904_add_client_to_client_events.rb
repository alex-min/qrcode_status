class AddClientToClientEvents < ActiveRecord::Migration
  def change
    add_reference :client_events, :client, index: true, foreign_key: true
  end
end

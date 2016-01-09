class AddLastMessageToClientEvents < ActiveRecord::Migration
  def change
    add_column :client_events, :last_message, :boolean
  end
end

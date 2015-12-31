class AddMessageToClientEvents < ActiveRecord::Migration
  def change
    add_column :client_events, :message, :text
  end
end

class AddEventCodeToClientEvents < ActiveRecord::Migration
  def change
    add_column :client_events, :event_code, :string
  end
end

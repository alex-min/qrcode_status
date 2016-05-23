class AddEventNameToClientEvent < ActiveRecord::Migration
  def change
    unless ClientEvent.column_names.include?('event_name')
      add_column :client_events, :event_name, :string
    end
  end
end

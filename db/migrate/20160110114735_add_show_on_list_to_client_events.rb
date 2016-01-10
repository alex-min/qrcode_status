class AddShowOnListToClientEvents < ActiveRecord::Migration
  def change
    add_column :client_events, :show_on_list, :boolean
  end
end

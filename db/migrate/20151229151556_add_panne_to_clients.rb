class AddPanneToClients < ActiveRecord::Migration
  def change
    add_column :clients, :panne, :string
  end
end

class AddFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :postal_code, :string
    add_column :clients, :city, :string
  end
end

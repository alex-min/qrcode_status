class AddProductNameToClients < ActiveRecord::Migration
  def change
    add_column :clients, :product_name, :string
  end
end

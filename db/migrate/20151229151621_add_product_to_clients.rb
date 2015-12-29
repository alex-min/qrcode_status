class AddProductToClients < ActiveRecord::Migration
  def change
    add_column :clients, :product, :string
  end
end

class AddBrandToClients < ActiveRecord::Migration
  def change
    add_column :clients, :brand, :string
  end
end

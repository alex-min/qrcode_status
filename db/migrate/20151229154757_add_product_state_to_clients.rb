class AddProductStateToClients < ActiveRecord::Migration
  def change
    add_column :clients, :product_state, :string
  end
end

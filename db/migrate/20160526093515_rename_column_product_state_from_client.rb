class RenameColumnProductStateFromClient < ActiveRecord::Migration
  def change
    rename_column :clients, :product_state, :legacy_product_state
  end
end

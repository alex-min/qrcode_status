class CreateProductStates < ActiveRecord::Migration
  def change
    create_table :product_states do |t|
      t.string :name
      t.string :legacy_slug

      t.timestamps null: false
    end
  end
end

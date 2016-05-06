class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.string :name
      t.boolean :enabled, null: false

      t.timestamps null: false
    end
  end
end

class AddLegacySlugToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :legacy_slug, :string
  end
end

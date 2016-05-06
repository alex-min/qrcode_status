class AddCompanyToProductTypes < ActiveRecord::Migration
  def change
    add_reference :product_types, :company, index: true, foreign_key: true
  end
end

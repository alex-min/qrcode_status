class AddCompanyToProductState < ActiveRecord::Migration
  def change
    add_reference :product_states, :company, index: true, foreign_key: true
  end
end

class AddProductTypeToClientEvent < ActiveRecord::Migration
  def change
    add_reference :client_events, :product_type, index: true, foreign_key: true
  end
end

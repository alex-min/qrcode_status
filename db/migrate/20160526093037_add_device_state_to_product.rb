class AddDeviceStateToProduct < ActiveRecord::Migration
  def change
    add_reference :clients, :product_state, index: true, foreign_key: true
  end
end

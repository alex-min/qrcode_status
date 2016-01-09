class AddProcessedToClient < ActiveRecord::Migration
  def change
    add_column :clients, :processed, :boolean
  end
end

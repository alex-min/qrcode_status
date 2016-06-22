class AddDemoToClient < ActiveRecord::Migration
  def change
    add_column :clients, :demo, :boolean
  end
end

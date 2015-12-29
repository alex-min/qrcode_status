class ChangePanneTypeOfClients < ActiveRecord::Migration
  def up
    change_column :clients, :panne, :text
  end

  def down
    change_column :clients, :panne, :string
  end
end

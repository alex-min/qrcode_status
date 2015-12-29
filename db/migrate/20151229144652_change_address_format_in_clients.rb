class ChangeAddressFormatInClients < ActiveRecord::Migration
  def up
    change_column :clients, :address, :string
  end

  def down
    change_column :clients, :address, :text
  end
end

class AddEtatToClients < ActiveRecord::Migration
  def change
    add_column :clients, :etat, :string
  end
end

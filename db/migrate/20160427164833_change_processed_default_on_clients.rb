class ChangeProcessedDefaultOnClients < ActiveRecord::Migration
  def change
    change_column :clients, :processed, :boolean, :default => false
  end
end

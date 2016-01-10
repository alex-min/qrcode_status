class UpdateAllClients < ActiveRecord::Migration
  def change
    Client.all.map(&:save!)
  end
end

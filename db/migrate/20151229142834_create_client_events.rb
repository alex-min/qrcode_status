class CreateClientEvents < ActiveRecord::Migration
  def change
    create_table :client_events do |t|
      t.timestamps null: false
    end
  end
end

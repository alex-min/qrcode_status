class AddSmsSentToClientEvents < ActiveRecord::Migration
  def change
    add_column :client_events, :sms_sent, :boolean
  end
end

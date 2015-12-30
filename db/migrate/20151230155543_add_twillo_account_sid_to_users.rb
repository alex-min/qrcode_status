class AddTwilloAccountSidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twillo_account_sid, :string
  end
end

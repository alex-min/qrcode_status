class AddTwilloRootPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twillo_root_phone, :string
  end
end

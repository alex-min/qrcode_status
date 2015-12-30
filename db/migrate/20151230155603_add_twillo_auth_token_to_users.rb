class AddTwilloAuthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twillo_auth_token, :string
  end
end

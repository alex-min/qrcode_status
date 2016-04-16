class AddActionToUserMessages < ActiveRecord::Migration
  def change
    add_column :user_messages, :action, :string
  end
end

class CreateUserMessages < ActiveRecord::Migration
  def change
    create_table :user_messages do |t|
      t.string :code
      t.string :title
      t.string :message

      t.timestamps null: false
    end
  end
end

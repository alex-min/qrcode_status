class AddCompanyToUserMessages < ActiveRecord::Migration
  def change
    add_reference :user_messages, :company, index: true, foreign_key: true
  end
end

class AddCommentToClientEvent < ActiveRecord::Migration
  def change
    unless ClientEvent.column_names.include?('comment')
      add_column :client_events, :comment, :text
    end
  end
end

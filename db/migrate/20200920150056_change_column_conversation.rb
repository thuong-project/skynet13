class ChangeColumnConversation < ActiveRecord::Migration[6.0]
  def change
    rename_column :conversations, :sender_id, :user1_id
    rename_column :conversations, :recipient_id, :user2_id
    add_column :conversations, :user1_status, :boolean, default: false
    add_column :conversations, :user2_status, :boolean, default: false
    add_column :conversations, :user1_unread, :int, default: 0
    add_column :conversations, :user2_unread, :int, default: 0
  end
end

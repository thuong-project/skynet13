# frozen_string_literal: true

class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      t.integer :sender_id, index: true
      t.integer :recipient_id, index: true
      t.timestamps
    end
    add_index :conversations, %i[sender_id recipient_id], unique: true
  end
end

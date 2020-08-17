class AddOnlineToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :online, :boolean, default: :false
  end
end

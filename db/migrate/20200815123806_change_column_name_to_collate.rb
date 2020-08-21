# frozen_string_literal: true

class ChangeColumnNameToCollate < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :name
  end
end

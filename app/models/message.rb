# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  default_scope -> { order(created_at: :asc) }
end

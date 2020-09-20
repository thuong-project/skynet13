# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'

  validates :user1_id, uniqueness: { scope: :user2_id }

  scope :between, lambda { |user1_id, user2_id|
    where(user1_id: user1_id, user2_id: user2_id).or(
      where(user1_id: user2_id, user2_id: user1_id)
    )
  }

  def self.get(user1_id, user2_id)
    conversation = between(user1_id, user2_id).first
    return conversation if conversation.present?

    create(user1_id: user1_id, user2_id: user2_id)
  end

  def opposed_user(user)
    user == user1 ? user2 : user1
  end

  def set_status(user_id, status)

    if user_id == self.user1_id 
      self.update(user1_status: status)
    else
      self.update(user2_status: status)
    end
  end

  def self.get_notices(user_id)
    output = []
    conversations = Conversation.all
    conversations.each do |c|
      if user_id == c.user1_id && c.user1_unread > 0
        output << {c.user2_id => c.user1_unread}        
      elsif user_id == c.user2_id && c.user2_unread > 0
        output << {c.user1_id => c.user2_unread}
      end
    end
    return output
  end


  def set_read(user_id)
    if user_id == self.user1_id
      self.update(user1_unread: 0)
    else
      self.update(user2_unread: 0)
    end
  end

  def user_active? user_id
    if user_id == self.user1_id
      user1_status ? true : false
    else
      user2_status ? true : false
    end
  end

  def add_unread user_id
    if user_id == self.user1_id
      count = self.user1_unread + 1
      self.update(user1_unread: count)
      return count
    else
      count = self.user2_unread + 1
      self.update(user2_unread: count)
      return count
    end
  end

end

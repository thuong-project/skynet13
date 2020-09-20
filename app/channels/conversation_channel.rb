# frozen_string_literal: true

# app/channels/appearance_channel.rb
class ConversationChannel < ApplicationCable::Channel
  def subscribed
    setting()

    @conversation.set_status(current_user.id, true)
    @conversation.set_read(current_user.id)
    ActionCable.server.broadcast(
      "mess_notice_#{current_user.id}",
      {notices: [{@opposed_user.id => 0}]}
    )

    stream_from(@channel)


    data_send = {}
    data_send['content'] = @conversation.messages.to_json
    data_send['to_user'] = current_user.id
    data_send['type'] = "all_mess"


    ActionCable.server.broadcast(
      @channel,
      data: data_send
    )
  end

  def unsubscribed
    @conversation.set_status(current_user.id, false)
  end

  def receive(payload)
    setting
    data_send = {}

    if payload['type'] === 'new_mess'

      unless @conversation.user_active?(@opposed_user.id)
        count = @conversation.add_unread(@opposed_user.id)
        ActionCable.server.broadcast(
          "mess_notice_#{@opposed_user.id}",
          {notices: [{current_user.id => count}]}
        )
      end

      new_mess = @conversation.messages.create(user_id: current_user.id, body: payload['message'])
      array_mess = [new_mess]
      data_send['type'] = 'new_mess'
      data_send['content'] = array_mess.to_json
    elsif payload['type'] === 'typing'
      payload['sender'] = current_user.to_json
      payload['recipient'] = @opposed_user.to_json
      data_send = payload
    end

    ActionCable.server.broadcast(
      @channel,
      data: data_send
    )
  end

  private

  def setting
    @conversation = Conversation.includes(:user1, :user2).find(params[:conversation_id])
    @opposed_user = @conversation.opposed_user(current_user)

    return unless current_user.id == @conversation.user1_id ||
                  current_user.id == @conversation.user2_id

    @channel = "conversation_#{@conversation.id}"
  end
end

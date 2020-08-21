# frozen_string_literal: true

# app/channels/appearance_channel.rb
class ConversationChannel < ApplicationCable::Channel
  def subscribed
    setting()

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

  def unsubscribed; end

  def receive(payload)
    setting
    data_send = {}

    if payload['type'] === 'new_mess'
      new_mess = @conversation.messages.create(user_id: current_user.id, body: payload['message'])
      array_mess = [new_mess]
      data_send['type'] = 'new_mess'
      data_send['content'] = array_mess.to_json
    elsif payload['type'] === 'typing'
      payload['sender'] = current_user.to_json
      payload['recipient'] = @conversation.recipient.to_json
      data_send = payload
    end

    ActionCable.server.broadcast(
      @channel,
      data: data_send
    )
  end

  private

  def setting
    @conversation = Conversation.includes(:sender, :recipient).find(params[:conversation_id])

    return unless current_user.id == @conversation.sender_id ||
                  current_user.id == @conversation.recipient_id

    @channel = "conversation_#{@conversation.id}"
  end
end

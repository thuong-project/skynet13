#app/channels/appearance_channel.rb
class ConversationChannel < ApplicationCable::Channel

  def subscribed
    
    return unless checkAuthor

    conversation = Conversation.find(params[:conversation_id])

    channel = "conversation_#{conversation.id}"
    stream_from channel

    ActionCable.server.broadcast(
      channel,
      messages: conversation.messages.to_json
    )
  end

  def unsubscribed
    
  end

  private
    def checkAuthor
      
      cvs = Conversation.find(params[:conversation_id])
     current_user.id == cvs.sender_id || current_user.id == cvs.recipient_id
    end
end
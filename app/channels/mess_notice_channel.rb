# frozen_string_literal: true

# app/channels/appearance_channel.rb
class MessNoticeChannel < ApplicationCable::Channel
    

    def subscribed
      @channel = "mess_notice_#{current_user.id}"
      stream_from(@channel)
      notices = Conversation.get_notices(current_user.id)
  
      data_send = {}
      data_send['notices'] = notices
  
      ActionCable.server.broadcast(
        @channel,
        data_send
      )
      
    end
  
    def unsubscribed
      
    end
  
    def receive(payload)
    end  
end
  
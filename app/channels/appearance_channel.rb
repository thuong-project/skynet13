# frozen_string_literal: true

# app/channels/appearance_channel.rb
class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    return unless current_user
   
    
   
    
    stream_from('appearance_user')
    current_user.update(online: true)
    ActionCable.server.broadcast(
      'appearance_user',
      current_user
    )
  end

  def unsubscribed
    another = false;
    ActionCable.server.connections.each do |conn|
      conn_id = conn.connection_identifier.split(':')[0]
      puts conn_id
      if conn_id.to_s == current_user.id.to_s
        another = true
        break
      end
    end
    current_user.update(online: false) unless another
    ActionCable.server.broadcast(
      'appearance_user',
      current_user
    )
  end
end

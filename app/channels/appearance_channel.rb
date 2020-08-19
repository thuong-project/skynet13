#app/channels/appearance_channel.rb
class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    
    return unless current_user
    current_user.update(online: true)
    stream_from "appearance_user"
  end

  def unsubscribed
    
    return unless current_user
    current_user.update(online: false)
  end

end
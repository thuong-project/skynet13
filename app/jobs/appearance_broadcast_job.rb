#app/jobs/appearance_broadcast_job.rb
class AppearanceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user)
    ActionCable.server.broadcast "appearance_user", render_json(user)
  end

  private

  def render_json(user)
    ApplicationController.renderer.render(json: user)
  end

end
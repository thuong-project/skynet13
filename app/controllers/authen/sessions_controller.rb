# frozen_string_literal: true

class Authen::SessionsController < Devise::SessionsController
  before_action :set_status_offline, only: :destroy

  def set_status_offline
    current_user.update(online: false)
  end

  private
    def after_sign_in_path_for(_resource)
      
      current_user.update(online: true)
      newsfeed_path
    end

    def after_sign_out_path_for(_resource)
      new_user_session_path
    end
end

class Users::SessionsController < Devise::SessionsController

  before_action :set_status_offline, only: :destroy
  
  def set_status_offline
    current_user.update(online: false)
  end
end
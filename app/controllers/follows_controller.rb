# frozen_string_literal: true

class FollowsController < ApplicationController
  
  before_action :set_user

  # GET /users/1/following.js
  def following
    @pagy, @users = pagy(@user.following, link_extra: 'data-remote="true" data-type="script"')
    @heading = 'following'
    render 'list_follow'
  end

  # GET /users/1/follows/js
  def followers
    @pagy, @users = pagy(@user.followers, link_extra: 'data-remote="true" data-type="script"')
    @heading = 'followers'
    render 'list_follow'
  end

  # POST /users/1/follow.js
  def follow
    if current_user.following? @user
      current_user.unfollow(@user)
    else
      current_user.follow(@user)
    end
  end

  private
    # SET user of current page
    def set_user
      @user = User.find(params[:user_id])
    end
end

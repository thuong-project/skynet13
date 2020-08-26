# frozen_string_literal: true

class UsersController < ApplicationController
  layout 'home'
  before_action :set_user, only: %i[show edit update destroy follow posts following followers follow]
  
  
  def home
    @user = current_user
    @pagy, @posts = pagy(current_user.posts)
  end

  def newsfeed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    @rs = Post.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: current_user.id)
    @pagy, @posts = pagy(@rs)
    render 'posts/newsfeed'
  end

  # GET /users
  # GET /users.json
  def index
    @pagy, @users = pagy(User.all)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    
  end

  
  # GET /users/1/edit
  def edit
    
  end

  # PUT/PATCH /users/1
  def update
    if current_user.update(user_params)
       @notice= "Update profile successfully"
    end
    render 'edit'
  end

  def search
    pr = { field: params[:field], value: params[:value] }
    @pagy, @users = pagy(User.search(pr))
  end

  private

  def set_user
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :avatar)
  end

end

# frozen_string_literal: true

class UsersController < ApplicationController
  layout 'home'
  before_action :set_user, only: %i[show edit update destroy follow posts following followers follow]

  # GET /home
  def home
    @user = current_user
  end

  def newsfeed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    @rs = Post.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: current_user.id)
    @pagy, @posts = pagy(@rs)
    render 'posts/newsfeed'
  end

  def create_post
    current_user.posts.create(content: params[:content])
    redirect_to newsfeed_user_url(current_user)
  end

  def posts
    @pagy, @posts = pagy(@user.posts, link_extra: 'data-remote="true" data-type="script"')
    respond_to do |format|
      format.js { render 'posts/list_posts' }
    end
  end

  def following
    @pagy, @users = pagy(@user.following, link_extra: 'data-remote="true" data-type="script"')
    @heading = 'following'
    respond_to do |format|
      format.js { render :list_follow }
    end
  end

  def followers
    @pagy, @users = pagy(@user.followers, link_extra: 'data-remote="true" data-type="script"')
    @heading = 'followers'
    respond_to do |format|
      format.html
      format.js { render :list_follow }
    end
  end

  def follow
    if current_user.following? @user
      current_user.unfollow(@user)
    else
      current_user.follow(@user)
    end
  end

  # GET /users
  # GET /users.json
  def index
    @pagy, @users = pagy(User.all)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render :home
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    pr = { field: params[:field], value: params[:value] }
    @pagy, @users = pagy(User.search(pr))
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email)
  end
end

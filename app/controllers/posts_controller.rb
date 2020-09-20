# frozen_string_literal: true

class PostsController < ApplicationController
 
  before_action :set_user
  before_action :set_post, except: [:index, :create]
  before_action :check_author, only: [:destroy, :update, :edit]
  
  # GET /users/1/posts/index.js
  def index
    @pagy, @posts = pagy(@user.posts, link_extra: 'data-remote="true" data-type="script"')
    respond_to do |format|
      format.js { render 'posts/list_posts' }
    end
  end

  # POST /users/1/
  def create
    current_user.posts.create(content: params[:content], images: params[:images])
    redirect_to newsfeed_url
  end

  def show
  end

  def edit 
  end

  # PUT/PATCH /users/1/posts/1
  def update
     unless params[:images].nil? 
        @post.images.purge
        @post.images.attach(params[:images])
     end
     @post.update(params.permit(:content));
     
  end

  # DELETE /users/1/posts/1
  def destroy
    @post.destroy
  end

  

  private
    # SET user of current page
    def set_user
      @user = User.find(params[:user_id])
    end 
    def set_post
      @post = Post.find(params[:id])
    end
    def check_author
      redirect_to root_path if @post.user_id != current_user.id
    end
end

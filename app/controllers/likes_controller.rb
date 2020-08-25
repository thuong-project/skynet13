# frozen_string_literal: true

class LikesController < ApplicationController
 
  before_action :setup
  # GET /posts/1/likes
  def index
  end

  # POST /posts/1/like
  def create
    @post.likes.create(user_id: current_user.id)
  end

  # DELETE /posts/1/like
  def destroy
    @post.likes.find_by(user_id: current_user.id).destroy
  end

  private
    
    def setup
      @post = Post.find(params[:post_id])  
    end
    
end

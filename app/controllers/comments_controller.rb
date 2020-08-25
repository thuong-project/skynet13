# frozen_string_literal: true

class CommentsController < ApplicationController
 
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]
  # GET /posts/1/comments
  def index
  end

  # POST /posts/1/comments
  def create
    @comment = @post.comments.create(user_id: current_user.id, content: params[:content])
  end

  # GET /posts/1/comments/1
  def edit
  end

  # PUT/PATCH /posts/1/comments/1
  def update
    @comment.update(update_params)
  end

  # DELETE /posts/1/like
  def destroy
    @comment.destroy
  end

  private
    
    def set_post
      @post = Post.find(params[:post_id])  
    end
    def set_comment
      @comment = Comment.find(params[:id])
      redirect_to  root_path if @comment.user_id != current_user.id
    end
    def update_params
      params.permit(:content)
    end
end

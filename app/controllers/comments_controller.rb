class CommentsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new comment_params
    @comment.user = current_user
    @comment.save
    redirect_to post_path(@post), notice: "Your comment was successful."
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    if @comment.update(comment_params)
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if current_user == @comment.user
      @comment.destroy
      redirect_to post_path(@post)
    end
  end


  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end

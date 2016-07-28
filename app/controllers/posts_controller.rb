class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.all
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    # @user = User.find(params[:id]) doesnt work
    # i think from session i should retrieve user id
    @user = current_user
    @post = @user.posts.create(post_params)

    if @post.save
      redirect_to @post, notice: "Your post was successful."
    else
      render 'new'
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params) && current_user == @post.user
      redirect_to @post
    else
      redirect_to(@post, notice: "You cannot edit this post")
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to posts_path
  end


  private
    def post_params
      params.require(:post).permit(:title, :body)
    end

end

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:show, :index]


  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Your post was created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit  
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post updated successfully"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format|

      format.html do 

        if @vote.valid?
          flash[:notice] = "Vote counted"
        else
          flash[:error] = "You have already voted on this post."
        end
        redirect_to :back
      end

      format.js
    end

  end

  private

  def post_params
    #when permitting an array it needs to be in the form of permit(:category_ids [])
    params.require(:post).permit!
  end

  def set_post
    @post = Post.find(params[:id])
  end
end

class CommentsController < ApplicationController
#need to define the post and comment objects here
#comments.create = User.first
before_action :require_user

  def create
    @comment = Comment.new(comment_params)
    @post = Post.find(params[:post_id])
    #@comment = @post.comments.build(comment_params)
    @comment.creator = User.first

    if @comment.save
      @post.comments << @comment #see above
      flash[:notice] = "Comment created successfully!"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
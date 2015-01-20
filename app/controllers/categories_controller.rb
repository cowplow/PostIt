class CategoriesController < ApplicationController
  before_action :require_user, only: [:new, :create]
  before_action :require_admin, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(slug: params[:id])
    @posts = @category.posts.sort_by{|x| x.total_votes}.reverse
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "New Category Created!"
      redirect_to categories_path
    else
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !logged_in? || !current_user.is_admin?
      flash[:error] = "You do not have sufficient privileges to perform that action."
      redirect_to root_path
    end
  end

end
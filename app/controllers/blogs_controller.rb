class BlogsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update]
  before_action :check_author, only: :update
  
  def index
    @blogs = Blog.all
    render json: @blogs
  end

  def show
    @blog = Blog.find(params[:id])
    render json: {
      blog: @blog,
      author: @blog.user.email
    }
  end

  def create
    @blog = @current_user.blogs.build(blog_params)
    if @blog.valid? && @blog.save
      render json: {
        message: 'Created Blog Successfully',
        data:{
          title: @blog.title,
          description: @blog.description
        }
      }, status: :ok
    else
      render json: {
        message: @blog.errors.full_messages.first,
        data:{}
      }, status: :unprocessable_entity
    end
  end

  def update
    if @blog.valid? && @blog.save
      render json: {
        message: 'Updated Blog Successfully',
        data:{
          title: @blog.title,
          description: @blog.description,
          author: @blog.user.email
        }
      }, status: :ok
    else
      render json: {
        message: @blog.errors.full_messages.first,
        data:{}
      }, status: :unprocessable_entity
    end
  end

  private

  def check_author
    @blog = Blog.find(params[:id])
    if @blog.user == @current_user
      return @blog
    else
      render json: {
        message: 'User is not the author',
        data: {},
      }, status: :unauthorized
    end
  end

  def authenticate_user
    @current_user = User.find_by(authentication_token: request.headers['Authorization'])
    if @current_user
      return @current_user
    else
      render json: {
        messages: 'Cannot find user',
        is_success: false,
        data: {},
      }, status: :unauthorized
    end
  end

  def blog_params
    params.require(:blog).permit(:title, :description)
  end
end

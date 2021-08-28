class UserBlogsController < ApplicationController
  before_action :authenticate, only: :index

  def index
    @blogs = @user.blogs.all
    render json: @blogs
  end


  private

  def authenticate
    @user = User.find_by(authentication_token: request.headers['Authorization'])
    if @user
      return @user
    else
      render json:{
        message: 'Cannot Find User',
        data: {},
      }, status: :unauthorized
    end
  end
end
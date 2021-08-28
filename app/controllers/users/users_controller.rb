class Users::UsersController < ApplicationController

  def show
    @user = User.find_by(authentication_token: request.headers['Authorization'])
    if @user
      render :json => @user
    else
      render json:{
        message: 'Cannot Find User',
        data: {}
      }, status: :unauthorized
    end
  
  end
end

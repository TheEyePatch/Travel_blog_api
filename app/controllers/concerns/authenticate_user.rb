module AuthenticateUser
  def current_user
    auth_token = request.headers["Authorization"]
    return unless auth_token
    @current_user = User.find_by(authentication_token: auth_token)
  end

  def authenticate
    return if @current_user
    render json: {
      messages: 'Cannot find user',
      is_success: false,
      data: {},
    }, status: :unauthorized
  end

end
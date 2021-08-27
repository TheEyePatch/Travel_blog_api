class Users::SessionsController < Devise::SessionsController
  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create
  before_action :valid_token, only: :destroy
  skip_before_action :verify_signed_out_user, only: :destroy
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in :user, @user
      render json: {
        messages: 'Signed in Successfully',
        is_success: true,
        data: {
          user: @user
        },
      }, status: :ok
    else  
      render json: {
        messages: 'Wrong Email or Password',
        is_success: false,
        data: {},
      }, status: :unauthorized
    end
  end

  # DELETE /resource/sign_out
  def destroy
    sign_out @user
    @user.generate_token
    render json: {
      messages: 'Signed Out Successfully',
      is_success: true,
      data: {
        user: @user
      },
    }, status: :ok
  end

  private

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    return @user if !@user.nil?
  end
  # If you have extra params to permit, append them to the sanitizer.
  def sign_in_params
    params.require(:sign_in).permit(:email, :password)
  end

  def valid_token
    @user = User.find_by(authentication_token: request.headers["Authorization"])
    if @user
      return @user
    else
      render json:{
        messages: 'Invalid Token',
        is_success: false,
        data: {},
      }, status: :not_acceptable
    end
  end
end

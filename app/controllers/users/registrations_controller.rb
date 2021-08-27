class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :require_no_authentication, only: [:new, :create, :cancel]
  before_action :ensure_params_exist, only: :create

  def create
    user = User.new(user_params)
    if user.valid? && user.save
      render json: {
        messages: 'Signed Up Successfully',
        is_success: true,
        data: {
          user: user
        },
      }, status: :ok
    else
      render json: {
        messages: user.errors.full_messages.first,
        is_success: false,
        data: {},
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def ensure_params_exist
    return if params[:user].present?
    render json: {
      messages: 'Missing params',
      is_success: false,
      data: {}
    }, status: :bad_request
  end
end

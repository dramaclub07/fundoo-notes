class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def send_otp
    result = UserService.send_otp(params[:email])
    render json: result, status: result[:success] ? :ok : :unprocessable_entity
  end

  def verify_otp
    result = UserService.verify_otp(params[:email], params[:otp])
    if result[:success]
      user = User.find_by(email: params[:email])
      render json: { success: true, message: result[:message], user: { id: user.id } }, status: :ok
    else
      render json: result, status: result[:success] ? :ok : :unprocessable_entity
    end
  end

  def register
    Rails.logger.info "Params received: #{params.inspect}"
    result = UserService.register(user_params)
    if result[:success]
      render json: { message: 'User registered successfully', user: result[:user] }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def login
    result = UserService.login(params[:email], params[:password])
    if result[:success]
      render json: { message: 'Login successful', user: result[:user], token: result[:token] }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :unauthorized
    end
  end

  def forgetpassword
    result = UserService.forgetpassword(fp_params)
    if result[:success]
      render json: { success: true, message: result[:message] }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :not_found
    end
  end

  def resetpassword
    user = User.find_by(id: params[:id])
    unless user
      return render json: { success: false, errors: ["User not found"] }, status: :not_found
    end
    result = UserService.verify_otp_and_reset_password(user.email, params[:otp], params[:new_password])
    if result[:success]
      render json: { success: true, message: result[:message] }, status: :ok
    else
      render json: { success: false, errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def profile
    auth_header = request.headers['Authorization']
    if auth_header && auth_header.start_with?('Bearer ')
      token = auth_header.split(' ').last
      decoded_token = JwtService.decode(token)
      user = User.find_by(id: decoded_token['user_id'])
      result = UserService.fetch_profile(user)
    else
      result = { success: false, errors: ["Unauthorized: No token provided"] }
    end
    if result[:success]
      render json: { user: result[:user] }, status: :ok
    else
      render json: { error: result[:errors] }, status: :unauthorized
    end
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:name, :email, :phone_number, :password, :password_confirmation)
  end

  def fp_params
    params.require(:user).permit(:email)
  end

  def rp_params
    params.permit(:new_password, :otp)
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
class Api::V1::UsersController < ApplicationController
  #skip_before_action :authenticate_user, only: [:register, :login, :forgetpassword, :resetpassword] # Skips authentication for these actions
  #skip_before_action :verify_authenticity_token, only: [:register, :login, :forgetpassword, :resetpassword]4
  skip_before_action :verify_authenticity_token

  def register
    Rails.logger.info "Params received: #{params.inspect}"
    result = UserService.register(user_params)
    if result[:success]
      render json: { message: 'User registered successfully', user: result[:user]}, status: :created
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

  # def forgetpassword
  #   result = UserService.forgetpassword(fp_params)
  #   if result[:success]
  #     render json: { message: result[:message] }, status: :ok
  #   else
  #     render json: { errors: result[:error] }, status: :not_found
  #   end
  # end

  def forgetpassword
    result = UserService.forgetpassword(fp_params)
    if result[:success]
      render json: { message: result[:message] }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :not_found
    end
  end

  def resetpassword
    user = User.find_by(id: params[:id])

    # Handling if user is not found
    unless user
      return render json: { errors: "User not found" }, status: :not_found
    end

    Rails.logger.info("Received OTP: #{rp_params[:otp]} for User ID: #{user.id}")

    result = UserService.verify_otp_and_reset_password(user.email, rp_params[:otp], rp_params[:new_password])

    if result[:success]
      render json: { message: "Password updated successfully" }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def profile
    result = UserService.fetch_profile(current_user)
    if result[:success]
      render json: { user: result[:user] }, status: :ok
    else
      render json: { error: result[:error] }, status: :unauthorized
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

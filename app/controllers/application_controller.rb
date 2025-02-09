class ApplicationController < ActionController::Base
  # protect_from_forgery with: :null_session, if: -> { request.format.json? }
  # skip_before_action :verify_authenticity_token, only: [:register, :login, :forgetpassword, :resetpassword]
  # before_action :authenticate_user

  # def current_user
  #   @current_user
  # end

  # private

  # # def authenticate_user
  # #   auth_header = request.headers['Authorization']
  # #   return render json: { error: 'Unauthorized' }, status: :unauthorized unless auth_header.present?

  # #   token = auth_header.split(' ')[1]
  # #   decoded = JwtService.decode(token) # Use JwtService for decoding
  # #   return render json: { error: 'Unauthorized' }, status: :unauthorized unless decoded

  # #   @current_user = User.find_by(id: decoded[:user_id])
  # #   return render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  # # rescue ActiveRecord::RecordNotFound
  # #   render json: { error: 'Unauthorized' }, status: :unauthorized
  # # end
end

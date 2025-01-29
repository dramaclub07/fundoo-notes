# require 'jwt'

# class AuthenticationController < ApplicationController
#   SECRET_KEY = Rails.application.credentials[:jwt_secret] || ENV['JWT_SECRET']

#   def create
#     user = User.new(user_params)
#     if user.save
#       token = generate_token(user)
#       render json: { user: user, token: token }, status: :created
#     else
#       render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
#     end
#   end

#   def login
#     user = User.find_by(email: params[:email])
#     if user&.authenticate(params[:password])
#       token = generate_token(user)
#       render json: { user: user, token: token }, status: :ok
#     else
#       render json: { error: "Invalid email or password" }, status: :unauthorized
#     end
#   end

#   private

#   def generate_token(user)
#     payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
#     JWT.encode(payload, SECRET_KEY, 'HS256')
#   end

#   def user_params
#     params.permit(:name, :email, :password, :password_confirmation)
#   end
# end

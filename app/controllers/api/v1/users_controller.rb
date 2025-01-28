class Api::V1::UsersController < ApplicationController
        skip_before_action :verify_authenticity_token

        def create
            user = User.new(user_params)
                if user.save
                    render json: {message: "User created successfully"}, status: :created
                else
                    render json: {message: "Failed to create user"}, status: :unprocessable_entity
                end
        end

        def user_params
            params.require(:user).permit(:name, :email, :password, :phone_number)
        end

end


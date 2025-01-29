class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session  # ✅ This disables CSRF for API requests
  before_action :authenticate_user

  def current_user
    @current_user ||= authenticate_user
  end

  private

  def authenticate_user
    auth_header = request.headers['Authorization']
    return nil unless auth_header.present?

    token = auth_header.split(' ')[1]
    decoded = JwtService.decode(token) # Use JwtService for decoding
    return nil unless decoded

    @current_user = User.find_by(id: decoded[:user_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
require 'jwt'

class JwtService
  SECRET_KEY = ENV['JWT_SECRET_KEY'] || 'fallback_secret_key'

  # Encode a JWT Token
  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  # Decode a JWT Token
  def self.decode(token)
    begin
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithms: ['HS256'] })[0]
      payload = HashWithIndifferentAccess.new(decoded)

      Rails.logger.info "Decoded JWT payload: #{payload}"

      # Always return a User object or nil
      User.find_by(id: payload[:id])     #changed [:user_id])
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message}")
      nil
    rescue StandardError => e
      Rails.logger.error("Unexpected Error: #{e.message}")
      nil
    end
  end
end

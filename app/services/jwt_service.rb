require 'jwt'

class JwtService
  SECRET_KEY = ENV['JWT_SECRET_KEY'] || 'fallback_secret_key'

  # Encode a JWT Token
  def self.encode(payload, exp = Time.current + 7.days)
    payload[:exp] = exp.to_i # Set expiration time
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  # Decode a JWT Token
  def self.decode(token)
    Rails.logger.info "Received JWT Token: #{token.inspect}"
    return nil unless token.is_a?(String) && !token.strip.empty?

    begin
      decoded_token = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
      payload = HashWithIndifferentAccess.new(decoded_token)

      Rails.logger.info "Decoded JWT payload: #{payload.inspect}"

      user_id = payload[:user_id]
      return nil unless user_id

      user = User.find_by(id: user_id)

      if user
        Rails.logger.info "User found: #{user.inspect}"
        return { "user_id" => user.id }                         # Return a hash with the user_id
        return { user: user } # Return a hash with the user object
      else
        Rails.logger.warn "User with ID #{user_id} not found!"
        return nil
      end

    rescue JWT::ExpiredSignature
      Rails.logger.error("JWT Token has expired: #{token.inspect}")
      return nil
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message} | Token: #{token.inspect}")
      return nil
    rescue StandardError => e
      Rails.logger.error("Unexpected Error: #{e.message} | Token: #{token.inspect}")
      return nil
    end
  end
end

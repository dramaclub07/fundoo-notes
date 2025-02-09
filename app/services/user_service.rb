require 'bunny'
class UserService
  class AuthenticationError < StandardError; end
  class UserNotFoundError < StandardError; end


  def self.register(user_params)
    user = User.new(user_params)
    if user.save
      # UserMailer.welcome_email(user).deliver_now
      { success: true, user: user }
    else
      { success: false, errors: user.errors.full_messages }
    end
  end

  # def self.forgetpassword(params)
  #   user = User.find_by(email: params[:email])
  #   return { success: false, errors: "User Not Found" } unless user

  #   otp = user.generate_otp
  #   begin
  #     UserMailer.send_otp_email(user, otp).deliver_now
  #     { success: true, message: "OTP sent to your email successfully" }
  #   rescue StandardError => e
  #     Rails.logger.error("OTP email failed: #{e.message}")
  #     { success: false, errors: "Failed to send OTP. Please try again later." }
  #   end
  # end

  def self.forgetpassword(params)
    user = User.find_by(email: params[:email])
    return { success: false, errors: "User Not Found" } unless user

    otp = user.generate_otp 
    otp_expiry = 10.minutes.from_now # Example expiry time

    # Publish the OTP message to RabbitMQ
    send_otp_to_queue(user.email, otp, otp_expiry)
    OtpWorker.start

    { success: true, message: "OTP is being processed and will be sent shortly." }
  end

  private

  def self.send_otp_to_queue(email, otp, otp_expiry)
    connection = Bunny.new
    connection.start
    channel = connection.create_channel
    queue = channel.queue('otp_queue', durable: true)

    message = { email: email, otp: otp, otp_expiry: otp_expiry.to_s }.to_json
    queue.publish(message, persistent: true)

    connection.close
  end

  def self.verify_otp_and_reset_password(email, otp, new_password)
    user = User.find_by(email: email)
    return { success: false, errors: "User not found" } unless user
    return { success: false, errors: "Invalid or expired OTP" } unless user.valid_otp?(otp)

    if user.update(password: new_password)
      user.clear_otp
      begin
        UserMailer.password_reset_successful(user).deliver_now
      rescue StandardError => e
        Rails.logger.error("Password reset email failed: #{e.message}")
      end
      { success: true, message: "Password reset successfully. A confirmation email has been sent." }
    else
      { success: false, errors: user.errors.full_messages.join(", ") }
    end
  end

  def self.login(email, password)
    begin
      user = User.find_by(email: email)
      raise UserNotFoundError, "Invalid Email" unless user
      raise AuthenticationError, "Invalid password" unless user.authenticate(password)

      token = JwtService.encode({ user_id: user.id })  # Generate token with JWT service
      { success: true, user: user, token: token }
    rescue UserNotFoundError, AuthenticationError => e
      Rails.logger.warn("Login failed: #{e.message}")
      { success: false, errors: [e.message] }
    rescue StandardError => e
      Rails.logger.error("Unexpected login error: #{e.message}")
      { success: false, errors: ["Something went wrong. Please try again later."] }
    end
  end

  def self.fetch_profile(user)
    if user
      { success: true, user: user }
    else
      { success: false, errors: "Unauthorized" }
    end
  end
end

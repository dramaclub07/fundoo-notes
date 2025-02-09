require 'bunny'

class OtpWorker
  def self.start
    connection = Bunny.new
    connection.start
    channel = connection.create_channel
    queue = channel.queue('otp_queue', durable: true)

    puts " [*] Waiting for OTP messages. To exit, press C TRL+C"

    queue.subscribe(block: true) do |delivery_info, _properties, body|
      otp_data = JSON.parse(body)
      send_otp_email(otp_data)
    end
  end
  

  def self.send_otp_email(otp_data)
    user = User.find_by(email: otp_data["email"])
    return unless user

    UserMailer.send_otp_email(user, otp_data["otp"], otp_data["otp_expiry"]).deliver_now
    puts " [x] OTP sent to #{otp_data["email"]}"
  rescue StandardError => e
    Rails.logger.error("Failed to send OTP email: #{e.message}")
  end
end
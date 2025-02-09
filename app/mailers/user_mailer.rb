class UserMailer < ApplicationMailer
  default from: 'priyanshupositive@gmail.com' 

#   def send_otp_email(user, otp_details)
#     @user = user
#     @otp = otp_details[:otp]         # Extract OTP from the hash
#     @otp_expiry = otp_details[:otp_expiry]  # Extract OTP expiry from the hash
#     mail(to: @user.email, subject: 'Your OTP Code')
#   end

#   def password_reset_successful(user)
#     @user = user
#     mail(to:@user.email,subject:'Your password has been successfully Reset')
#   end  
# end

  def send_otp_email(user, otp, otp_expiry)
    @user = user
    @otp = otp
    @otp_expiry = otp_expiry
    mail(to: @user.email, subject: 'Your OTP Code')
  end

end














# class UserMailer < ApplicationMailer
#     default from: 'priyanshupositive@gmail.com'

#     # def welcome_mail(user)
#     #     @user = user
#     #     mail(to: @user.email, subject: 'Welcome to our site')
#     # end

#     def password_reset_email(email, otp)
#         @message = "Here is your OTP #{otp}"
#         Rails.logger.info "Sending mail to #{email}, please wait.... "
#         mail(to: email, subject: 'Password Reset OTP')
#         Rails.logger.info "Sent Succesfully"
#     end 
# end
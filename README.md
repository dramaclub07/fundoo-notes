# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

```ruby
# config/environments/development.rb
config.action_mailer.default_url_options = { host: 'localhost:3000' }
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'gmail.com',
  user_name: 'priyanshupositive@gmail.com',
  password: 'your_password',
  authentication: 'plain',
  enable_starttls_auto: true
}

# config/environments/production.rb
config.action_mailer.default_url_options = { host: 'your_production_host' }
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'gmail.com',
  user_name: 'your_email@gmail.com',
  password: 'your_password',
  authentication: 'plain',
  enable_starttls_auto: true
}

# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def otp_email(user, otp)
    @user = user
    @otp = otp
    mail to: user.email, subject: 'Your OTP for login'
  end
end

# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      otp = rand(100000..999999)
      @user.update(otp: otp)
      UserMailer.otp_email(@user, otp).deliver_now
      redirect_to verify_otp_path
    else
      flash[:error] = 'Invalid email or password'
      render :new
    end
  end
end

# app/controllers/verify_otp_controller.rb
class VerifyOtpController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.otp == params[:otp]
      @user.update(otp: nil)
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:error] = 'Invalid OTP'
      render :new
    end
  end
end

# app/views/sessions/new.html.erb
<h1>Login</h1>
<%= form_for(:session, url: sessions_path) do |form| %>
  <%= form.label :email %>
  <%= form.text_field :email %>
  <%= form.label :password %>
  <%= form.password_field :password %>
  <%= form.submit %>
<% end %>

# app/views/verify_otp/new.html.erb
<h1>Verify OTP</h1>
<%= form_for(:verify_otp, url: verify_otp_path) do |form| %>
  <%= form.label :email %>
  <%= form.text_field :email %>
  <%= form.label :otp %>
  <%= form.text_field :otp %>
  <%= form.submit %>
<% end %>

# config/routes.rb
Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/verify_otp', to: 'verify_otp#new'
  post '/verify_otp', to: 'verify_otp#create'
end

# Description:
# This code generates a random OTP and sends it to the user's email after they enter their email and password.
# The user is then redirected to a page where they can enter the OTP to verify their login.
# If the OTP is correct, the user is logged in and the OTP is reset.
```


  
  def clear_otp
    self.class.remove_otp(email)
  end

  private

  # Class-level OTP store methods
  def self.otp_store
    @otp_store ||= {}  
  end

  def self.store_otp(email, otp,expiry)
    otp_store[email] = { otp: otp, expires_at: 2.minutes.from_now }
  end

  def self.fetch_otp(email)
    otp_store[email]
  end

  def self.remove_otp(email)
    otp_store.delete(email)
  end


end
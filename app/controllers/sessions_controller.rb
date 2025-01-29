class SessionsController < ApplicationController  
  def new  
  end  

  def create  
    # Modify this logic to match how you're handling users  
    user = User.find_by(email: params[:email])  
    if user&.authenticate(params[:password]) # Assuming you have a User model with bcrypt  
      session[:user_id] = user.id  
      redirect_to notes_path, notice: 'Logged in successfully'  
    else  
      flash.now[:alert] = 'Invalid email or password'  
      render :new  
    end  
  end  

  def destroy  
    session.delete(:user_id)  
    redirect_to root_path, notice: 'Logged out successfully'  
  end  
end
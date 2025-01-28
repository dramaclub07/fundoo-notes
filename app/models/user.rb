require 'bcrypt'
class User < ApplicationRecord  
  
  include BCrypt

  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9\s]+\z/, message: "Invalid name format" }
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/, message: "Invalid email format" }
  validates :password, presence: true, length: { minimum: 8 }, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/, message: "Password must contain at least one lowercase letter, one uppercase letter, one digit, and one special character" }
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A\d{10}\z/, message: "Phone number must be 10 digits" }

  before_save :hash_password

  private

  def hash_password
    self.password = BCrypt::Password.create(self.password)
  end
end 
  
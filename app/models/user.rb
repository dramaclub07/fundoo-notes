class User < ApplicationRecord 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable
  has_many :notes
  has_many :collaborations
  has_many :shared_notes, through: :collaborations, source: :note 
  
  has_secure_password
  #include BCrypt

  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9\s]+\z/, message: "Name can't be blank" }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email is invalid" }
  # validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/, message: "Invalid email format" }
  validates :password, presence: true, length: { minimum: 8 }, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/, message: "Password must contain at least one lowercase letter, one uppercase letter, one digit, and one special character" }
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }, length: { is: 10, message: "must be 10 digits" }
  #validates :phone_number, presence: true, uniqueness: true, length: {is: 14}, format: {
  #  with: /\A\+91[-\s]?\d{10}\z/, message: "must be an indian phone number starting with +91"}"

attr_accessor :otp_expiry
#instance methods

  def generate_otp
    otp = rand(100000..999999).to_s
    expiry = 10.minutes.from_now
    self.class.store_otp(email, otp, expiry)  # Pass expiry
    expiry_in_kolkata = expiry.in_time_zone('Asia/Kolkata')  # Convert expiry time to IST
    { otp: otp,otp_expiry: expiry_in_kolkata.to_s }
  end
  
  

  def valid_otp?(entered_otp)
    otp_data = self.class.fetch_otp(email)
    return false unless otp_data
    return false if Time.current > otp_data[:expires_at]
    otp_data[:otp] == entered_otp
  end



  
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

































# before_save :hash_password
  
  # def authenticate(input_password)
  #   Password.new(self.password) == input_password
  # end

  # private

  # def hash_password
  #   self.password = BCrypt::Password.create(self.password)
  # end
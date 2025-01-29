class UserService
  def self.register(params)
    user = User.new(params)
    if user.save
      { success: true, user: user }
    else
      { success: false, errors: user.errors.full_messages }
    end
  end

  def self.login(email, password)
    user = User.find_by(email: email)
    if user&.authenticate(password)
      token = JwtService.encode({ user_id: user.id })  # Generate token with JWT service
      { success: true, user: user, token: token }
    else
      { success: false, errors: ['Invalid email or password'] }
    end
  end

  def self.fetch_profile(user)
    user ? { success: true, user: user } : { success: false, error: 'Unauthorized' }
  end
end
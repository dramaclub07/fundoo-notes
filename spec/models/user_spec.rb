require 'rails_helper' 
RSpec.describe User, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should allow_value("John Doe").for(:name) }
    it { should_not allow_value("John@Doe!").for(:name) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value("test@example.com").for(:email) }
    it { should_not allow_value("invalid_email").for(:email) }

    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8) }
    it { should_not allow_value("12345678").for(:password) }
    it { should allow_value("Strong@123").for(:password) }

    it { should validate_presence_of(:phone_number) }
    it { should validate_uniqueness_of(:phone_number).case_insensitive }
    it { should allow_value("9876543210").for(:phone_number) }
    it { should_not allow_value("12345").for(:phone_number) }
  end

  describe "Associations" do
    it { should have_many(:notes) }
    it { should have_many(:collaborations) }
    it { should have_many(:shared_notes).through(:collaborations) }
  end

  # describe "Instance Methods" do
  #   let(:user) { create(:user) }

  #   it "generates a 6-digit OTP with expiry time" do
  #     expect(user.generate_otp.length).to eq(6)
  #   end

  #   it "validates OTP correctly" do
  #     user.generate_otp
  #     expect(user.validate_otp(user.otp)).to be true
  #   end

  #   it "clears OTP after use" do
  #     user.generate_otp
  #     user.clear_otp
  #     expect(user.otp).to be_nil
  #   end
  # end
end

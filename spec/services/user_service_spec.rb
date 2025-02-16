require 'rails_helper'

RSpec.describe UserService, type: :service do
  let(:user) { create(:user, password: "P@ssw0rd") }  # Ensure password meets validation rules

  describe ".register" do
    context "when valid user params are provided" do
      let(:valid_params) { attributes_for(:user, password: "P@ssw0rd") }

      it "creates a new user and returns success" do
        result = UserService.register(valid_params)

        expect(result[:success]).to be true
        expect(result[:user]).to be_persisted
      end
    end

    context "when invalid user params are provided" do
      let(:invalid_params) { { email: "", password: "" } }

      it "fails to create a user and returns errors" do
        result = UserService.register(invalid_params)

        expect(result[:success]).to be false
        expect(result[:errors]).to include("Email can't be blank", "Password can't be blank")
      end
    end
  end

  describe ".login" do
    context "when valid credentials are provided" do
      it "returns a success response with a token" do
        result = UserService.login(user.email, "P@ssw0rd")

        expect(result[:success]).to be true
        expect(result[:token]).not_to be_nil
      end
    end

    context "when incorrect password is provided" do
      it "returns an authentication error" do
        result = UserService.login(user.email, "WrongPassword")

        expect(result[:success]).to be false
        expect(result[:errors]).to include("Invalid password")
      end
    end

    context "when email is not found" do
      it "returns a user not found error" do
        result = UserService.login("nonexistent@example.com", "P@ssw0rd")

        expect(result[:success]).to be false
        expect(result[:errors]).to include("Invalid Email")
      end
    end
  end
end

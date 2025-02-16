require 'rails_helper'

RSpec.describe 'User Login API', type: :request do
  let!(:user) { create(:user, email: 'test@example.com', password: 'P@ssw0rd', phone_number: '9876543210') }

  describe 'POST /api/v1/users/login' do
    context 'when valid credentials are provided' do
      before do
        post '/api/v1/users/login', params: { user: { email: 'test@example.com', password: 'P@ssw0rd' } }
      end

      it 'returns a success message' do
        expect(response.status).to eq(200)
        expect(json['message']).to eq('Login successful')
      end

      it 'returns the user data' do
        expect(json['user']['email']).to eq('test@example.com')
      end

      it 'returns an authentication token' do
        expect(json['token']).not_to be_nil
      end
    end

    context 'when invalid credentials are provided' do
      before do
        post '/api/v1/users/login', params: { user: { email: 'test@example.com', password: 'wrongpassword' } }
      end

      it 'returns an error message' do
        expect(response.status).to eq(401)
        expect(json['errors']).to eq('Invalid email or password')
      end
    end

    context 'when the email does not exist' do
      before do
        post '/api/v1/users/login', params: { user: { email: 'nonexistent@example.com', password: 'P@ssw0rd' } }
      end

      it 'returns an error message' do
        expect(response.status).to eq(401)
        expect(json['errors']).to eq('Invalid email or password')
      end
    end
  end
end

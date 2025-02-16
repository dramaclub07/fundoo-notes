RSpec.describe UserService, type: :service do
  let!(:user) { create(:user, email: 'test@example.com', password: 'P@ssw0rd') }

  describe '.login' do
    context 'when valid credentials are provided' do
      it 'returns a success response with user and token' do
        result = UserService.login('test@example.com', 'P@ssw0rd')

        expect(result[:success]).to be_truthy
        expect(result[:user].email).to eq('test@example.com')
        expect(result[:token]).not_to be_nil
      end
    end

    context 'when invalid email is provided' do
      it 'returns an error message' do
        result = UserService.login('invalid@example.com', 'P@ssw0rd')

        expect(result[:success]).to be_falsey
        expect(result[:errors]).to include('Invalid Email')
      end
    end

    context 'when invalid password is provided' do
      it 'returns an error message' do
        result = UserService.login('test@example.com', 'wrongpassword')

        expect(result[:success]).to be_falsey
        expect(result[:errors]).to include('Invalid password')
      end
    end

    context 'when an unexpected error occurs' do
      it 'returns a generic error message' do
        allow(User).to receive(:find_by).and_raise(StandardError.new("Unexpected error"))

        result = UserService.login('test@example.com', 'P@ssw0rd')

        expect(result[:success]).to be_falsey
        expect(result[:errors]).to include('Something went wrong. Please try again later.')
      end
    end
  end
end

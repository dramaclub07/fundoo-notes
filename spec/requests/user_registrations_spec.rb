require 'rails_helper'

RSpec.describe 'User Registration', type: :request do
  def json_response
    JSON.parse(response.body)
  end

  it 'registers a new user with valid parameters' do
    valid_params = {
      user: {
        name: 'John Doe',
        email: 'john@example.com',
        phone_number: '9873569890',
        password: 'P@ssw0rd',
        password_confirmation: 'P@ssw0rd'
      }
    }

    post '/api/v1/register', params: valid_params

    expect(response).to have_http_status(:created)
    expect(json_response['message']).to eq('User registered successfully')
  end

  it 'returns validation errors for invalid parameters' do
    invalid_params = {
      user: {
        name: '',
        email: 'john@example.com',
        phone_number: '12345',
        password: 'P@ssw0rd',
        password_confirmation: 'mismatch'
      }
    }

    post '/api/v1/register', params: invalid_params

    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_response['errors']).to include("Name can't be blank", "Phone number must be 10 digits")
  end
end

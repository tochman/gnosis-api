RSpec.describe 'User Registration', type: :request do
  let(:header) { { HTTP_ACCEPT: 'application/json' } }

  context 'with valid credentials' do
    it 'returns a user info and 5 registration keys' do
      post '/api/v0/auth', params: { email: 'example@craftacademy.se',
                                      password: 'password',
                                      password_confirmation: 'password'
                                  }, headers: headers

      expect(response_json['status']).to eq 'success'
      expect(response.status).to eq 200
      expect(response_json['data']['registration_keys'].count).to eq 5
    end
  end

  context 'returns an error message when user submits' do
    it 'non-matching password confirmation' do
      post '/api/v0/auth', params: { email: 'example@craftacademy.se',
                                      password: 'password',
                                      password_confirmation: 'wrong_password'
                                  }, headers: headers

      expect(response_json['errors']['password_confirmation']).to eq ["doesn't match Password"]
      expect(response.status).to eq 422
    end

    it 'an invalid email address' do
      post '/api/v0/auth', params: { email: 'example@craft',
                                      password: 'password',
                                      password_confirmation: 'password'
                                  }, headers: headers

      expect(response_json['errors']['email']).to eq ['is not an email']
      expect(response.status).to eq 422
    end

    it 'an already registered email' do
      FactoryBot.create(:user, email: 'example@craftacademy.se',
                                password: 'password',
                                password_confirmation: 'password')

      post '/api/v0/auth', params: { email: 'example@craftacademy.se',
                                      password: 'password',
                                      password_confirmation: 'password'
                                  }, headers: headers

      expect(response_json['errors']['email']).to eq ['has already been taken']
      expect(response.status).to eq 422
    end
  end
end
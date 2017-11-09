require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  # Init Data
  let!(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }

  # GET /users
  describe 'GET /users' do
    before { get '/users' }

    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # GET /users/:id
  describe 'GET /users/:id' do
    before { get "/users/#{user_id}" }

    context 'when user exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user doesnt exists' do
      let(:user_id) { 90 }

      it 'returns code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  # POST /users
  describe 'POST /register' do
    let(:valid_attributes) { { email: 'pedrito.pablo@email.com', password: 'pedrito', artefact: 12345678 } }

    context 'when the request is valid' do
      before { post '/register', params: valid_attributes }

      it 'creates user' do
        p response.body
        expect(json['email']).to eq('pedrito.pablo@email.com')
      end

      it 'returns code 201' do
        expect(response).to have_http_status(201)
      end

      it 'creates 11 ideals (3 per sensor, 2 for sound)' do
        ideals = []
        Ideal.where(user_id: json['id'], active: true).find_each do |ideal|
          ideals.push(ideal)
        end
        expect(ideals.size).to eq(11)
      end
    end

    context 'when the request is invalid' do
      before { post '/register', params: {} }

      it 'returns code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Email can't be blank, Password digest can't be blank, Artefact can't be blank, Password can't be blank/)
      end
    end
  end

  # PUT /users/:id
  describe 'PUT /users/:id' do
    let(:valid_attributes) { { mode: 1 } }

    context 'when user exists' do
      before { put "/users/#{user_id}", params: valid_attributes }

      it 'updates user' do
        updated_user = User.find(user_id)
        expect(updated_user.mode).to eq(1)
      end

      it 'returns code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # DELETE /users/:id
  describe 'DELETE /users/:id' do
    before { delete "/users/#{user_id}" }

    it 'returns code 204' do
      expect(response).to have_http_status(204)
    end
  end
end

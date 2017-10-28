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
  describe 'POST /users' do
    let(:valid_attributes) { { name: 'Pedrito Pablo', email: 'pedrito.pablo@email.com', password: 'pedrito', mode: 0, artefact: 12345678, active: true } }

    context 'when the request is valid' do
      before { post '/users', params: valid_attributes }

      it 'creates user' do
        expect(json['name']).to eq('Pedrito Pablo')
      end

      it 'returns code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/users', params: { name: 'Manti' } }

      it 'returns code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Email can't be blank, Password digest can't be blank, Mode can't be blank, Artefact can't be blank, Active can't be blank, Password can't be blank/)
      end
    end
  end

  # PUT /users/:id
  describe 'PUT /users/:id' do
    let(:valid_attributes) { { mode: 1 } }

    context 'when user exists' do
      before { put "/users/#{user_id}", params: valid_attributes }

      it 'updates user' do
        expect(response.body).to be_empty
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
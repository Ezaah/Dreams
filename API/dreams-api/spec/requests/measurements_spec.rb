require 'rails_helper'

RSpec.describe 'Measurements API', type: :request do
  let!(:user) { create(:user) }
  let!(:measurements) { create_list(:measurement, 20, user_id: user.id) }
  let(:user_id) { user.id }
  let(:id) { measurements.first.id }

  describe 'GET /users/:user_id/measurements' do
    before { get "/users/#{user_id}/measurements" }

    context 'when user exists' do
      it 'returns code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all his measurements' do
        expect(json.size).to eq(20)
      end
    end

    context 'when user doesnt exists' do
      let(:user_id) { 0 }
      it 'returns code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  describe 'GET /users/:user_id/measurements/:id' do
    before { get "/users/#{user_id}/measurements/#{id}" }

    context 'when user measurements exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the measurement' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when user measurements doenst exists' do
      let(:id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(response.body).to match(/Couldn't find Measurement/)
      end
    end
  end

  describe 'GET /users/:user_id/measurements/last' do
    before { get "/users/#{user_id}/measurements/last" }

    context 'there is a measurement' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a measurement' do
        expect(json.size).to eq(1)
      end
    end
  end

  describe 'POST /users/:user_id/measurements' do
    let(:valid_attributes) { { light: 200, sound: 200, temperature: 25, humidity: 35 } }

    context 'when request attributes are valid' do
      before { post "/users/#{user_id}/measurements", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request attributes are invalid' do
      before { post "/users/#{user_id}/measurements", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(response.body).to match(/Validation failed: Light can't be blank, Sound can't be blank, Temperature can't be blank, Humidity can't be blank/)
      end
    end
  end

  describe 'PUT /users/:user_id/measurements/:id' do
    let(:valid_attributes) { { active: false } }

    before { put "/users/#{user_id}/measurements/#{id}", params: valid_attributes }

    context 'when measurement exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the measurement' do
        updated_measurement = Measurement.find(id)
        expect(updated_measurement.active).to eq(false)
      end
    end

    context 'when measurement doesnt exists' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(response.body).to match(/Couldn't find Measurement/)
      end
    end
  end

  describe 'DELETE /users/:user_id/measurements/:id' do
    before { delete "/users/#{user_id}/measurements/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end

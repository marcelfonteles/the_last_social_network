require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /api/v1/users" do
    before do
      FactoryBot.create_list(:user, 20)
    end

    it 'returns all users from page 1' do
      get '/api/v1/users'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(10)
    end

    it 'returns all users from page 2' do
      get '/api/v1/users', params: { page: 2, hits_per_page: 10 }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(10)
    end

    it 'returns empty array of users' do
      get '/api/v1/users', params: { page: 10, hits_per_page: 10 }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(0)
    end
  end

  describe "GET /api/v1/users/:id" do
    let (:user) { create(:user) }

    it 'returns user' do
      get "/api/v1/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      response_user = JSON.parse(response.body).deep_symbolize_keys!
      expect(response_user[:id]).to eq(user.id)
    end

    it 'returns an error' do
      get "/api/v1/users/999"

      expect(response).to have_http_status(:unprocessable_entity)
      res = JSON.parse(response.body).deep_symbolize_keys!
      expect(res[:message]).to eq("User not found.")
    end

  end

  # describe "POST /api/v1/users"
  # describe "PUT /api/v1/users"
end

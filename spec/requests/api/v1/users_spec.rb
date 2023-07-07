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
    let(:inventory_1) { create(:inventory, user: user, item: 'water') }
    let(:inventory_2) { create(:inventory, user: user, item: 'food') }
    let(:inventory_3) { create(:inventory, user: user, item: 'medicine') }
    let(:inventory_4) { create(:inventory, user: user, item: 'ammo') }


    it 'returns user' do
      user.reload
      inventory_1.reload
      inventory_2.reload
      inventory_3.reload
      inventory_4.reload

      get "/api/v1/users/#{user.id}"

      res = JSON.parse(response.body).deep_symbolize_keys!

      expect(response).to have_http_status(:ok)
      expect(res[:id]).to eq(user.id)
      expect(res[:inventories].size).to eq(4)
    end

    it 'returns an error' do
      get "/api/v1/users/999"

      res = JSON.parse(response.body).deep_symbolize_keys!

      expect(response).to have_http_status(:unprocessable_entity)
      expect(res[:message]).to eq("User not found.")
    end

  end

  describe "POST /api/v1/users" do
    it 'should creates a user' do
      params = {
        user: {
          name: 'Jane Doe',
          birthday: '1994-12-05',
          gender: 'female',
          last_latitude: rand(90),
          last_longitude: rand(180),
        }
      }

      post('/api/v1/users', params:)

      res = JSON.parse(response.body).deep_symbolize_keys

      expect(response).to have_http_status(:ok)
      expect(res[:name]).to eq('Jane Doe')
      expect(res[:birthday]).to eq('1994-12-05')
      expect(res[:gender]).to eq('female')
    end

    describe 'when has incorrect params' do
      it 'and name, gender OR birthday is NIL should NOT create a user' do
        params = {
          user: {
            last_latitude: rand(90),
            last_longitude: rand(180),
          }
        }

        post('/api/v1/users', params:)

        res = JSON.parse(response.body).deep_symbolize_keys

        expect(response).to have_http_status(:unprocessable_entity)
        expect(res[:name][0]).to eq("can't be blank")
        expect(res[:gender][0]).to eq("can't be blank")
        expect(res[:birthday][0]).to eq("can't be blank")
      end

      it 'and has incorrect latitude OR longitude should NOT create a user' do
        params = {
          user: {
            name: 'Jane Doe',
            birthday: '1994-12-05',
            gender: 'female',
            last_latitude: 92,
            last_longitude: 223,
          }
        }

        post('/api/v1/users', params:)

        res = JSON.parse(response.body).deep_symbolize_keys

        expect(response).to have_http_status(:unprocessable_entity)
        expect(res[:last_latitude][0]).to eq("must be less than or equal to 90.0")
        expect(res[:last_longitude][0]).to eq("must be less than or equal to 180.0")
      end
    end

  end

  describe "PUT /api/v1/users" do
    let(:user) { create(:user)}
    it 'should returns updated user' do
      params = {
        user: {
          name: 'Jane Doe',
          birthday: '1994-12-05',
          last_latitude: rand(90),
          last_longitude: rand(180),
        }
      }

      put("/api/v1/users/#{user.id}", params:)

      res = JSON.parse(response.body).deep_symbolize_keys

      expect(response).to have_http_status(:ok)
      expect(res[:name]).to eq('Jane Doe')
      expect(res[:birthday]).to eq('1994-12-05')
      expect(res[:last_latitude]).not_to be_nil
      expect(res[:last_longitude]).not_to be_nil
    end
  end
end

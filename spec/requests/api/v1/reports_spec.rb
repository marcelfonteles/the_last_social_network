require 'rails_helper'

RSpec.describe "Api::V1::Reports", type: :request do
  describe "GET /api/v1/reports" do
    before do
      10.times do
        user = create(:user)
        create(:inventory, user: user, item: 'water')
        create(:inventory, user: user, item: 'food')
        create(:inventory, user: user, item: 'medicine')
        create(:inventory, user: user, item: 'ammo')
      end

      get("/api/v1/reports")
    end

    subject(:res) { JSON.parse(response.body).deep_symbolize_keys }

    it 'returns success' do
      expect(response).to have_http_status(:ok)
    end

    it 'expect to have an object in body' do
      expect(res).to be_a_kind_of(Hash)
    end
  end
end

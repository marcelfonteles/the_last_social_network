require 'rails_helper'

RSpec.describe "Api::V1::Inventories", type: :request do
  describe "PUT /api/v1/users/:id/inventories" do
    context 'when success' do
      let(:user) { create(:user) }
      let(:inventory_1) { create(:inventory, user: user, item: 'water') }
      let(:inventory_2) { create(:inventory, user: user, item: 'food') }
      let(:inventory_3) { create(:inventory, user: user, item: 'medicine') }
      let(:inventory_4) { create(:inventory, user: user, item: 'ammo') }

      it 'should update inventory' do
        user.reload
        inventory_1.reload

        params = {
          inventory: {
            user_id: user.id,
            item: 'water',
            quantity: 12
          }
        }

        put("/api/v1/users/#{user.id}/inventories", params:)

        res = JSON.parse(response.body).deep_symbolize_keys

        expect(response).to have_http_status(:ok)
        expect(res[:item]).to eq('water')
        expect(res[:quantity]).to eq(12)
      end
    end

    context 'when error' do
      let(:user) { create(:user) }
      let(:inventory_1) { create(:inventory, user: user, item: 'water') }
      let(:inventory_2) { create(:inventory, user: user, item: 'food') }
      let(:inventory_3) { create(:inventory, user: user, item: 'medicine') }
      let(:inventory_4) { create(:inventory, user: user, item: 'ammo') }

      it 'and quantity bellow zero, should not update inventory' do
        user.reload
        inventory_1.reload

        params = {
          inventory: {
            user_id: user.id,
            item: 'water',
            quantity: -2
          }
        }

        put("/api/v1/users/#{user.id}/inventories", params:)

        res = JSON.parse(response.body).deep_symbolize_keys

        expect(response).to have_http_status(:unprocessable_entity)
        expect(res[:quantity]).to eq(['must be greater than or equal to 0'])
      end
    end
  end
end

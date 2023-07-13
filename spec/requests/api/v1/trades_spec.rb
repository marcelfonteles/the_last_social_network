require 'rails_helper'

RSpec.describe "Api::V1::Trades", type: :request do
  describe "POST /api/v1/trades" do
    context 'when success' do
      let(:user_1) { create(:user) }
      let(:inventory_1) { create(:inventory, user: user_1, item: 'water', quantity: 12) }
      let(:inventory_2) { create(:inventory, user: user_1, item: 'food', quantity: 12) }
      let(:inventory_3) { create(:inventory, user: user_1, item: 'medicine', quantity: 12) }
      let(:inventory_4) { create(:inventory, user: user_1, item: 'ammo', quantity: 12) }

      let(:user_2) { create(:user) }
      let(:inventory_5) { create(:inventory, user: user_2, item: 'water', quantity: 12) }
      let(:inventory_6) { create(:inventory, user: user_2, item: 'food', quantity: 12) }
      let(:inventory_7) { create(:inventory, user: user_2, item: 'medicine', quantity: 12) }
      let(:inventory_8) { create(:inventory, user: user_2, item: 'ammo', quantity: 12) }

      before do
        user_1.reload
        inventory_1.reload
        inventory_2.reload
        inventory_3.reload
        inventory_4.reload
        user_2.reload
        inventory_5.reload
        inventory_6.reload
        inventory_7.reload
        inventory_8.reload


        params = {
          "trade": {
            "user_trader_1": {
              "id": user_1.id,
              "send": {
                "water": 2,
                "food": 0,
                "medicine": 0,
                "ammo": 0
              }
            },
            "user_trader_2": {
              "id": user_2.id,
              "send": {
                "water": 0,
                "food": 0,
                "medicine": 0,
                "ammo": 8
              }
            }
          }
        }
        post("/api/v1/trades", params:)
      end

      it 'expect to has status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'expect to USER 1 has the correct amount of inventory items' do
        expect(user_1.amount_of_water.quantity).to eq(10)
        expect(user_1.amount_of_ammo.quantity).to eq(20)
      end

      it 'expect to USER 2 has the correct amount of inventory items' do
        expect(user_2.amount_of_water.quantity).to eq(14)
        expect(user_2.amount_of_ammo.quantity).to eq(4)
      end
    end

    context 'when error' do
      context 'when the total of points does not match' do
        let(:user_1) { create(:user) }
        let(:inventory_1) { create(:inventory, user: user_1, item: 'water', quantity: 12) }
        let(:inventory_2) { create(:inventory, user: user_1, item: 'food', quantity: 12) }
        let(:inventory_3) { create(:inventory, user: user_1, item: 'medicine', quantity: 12) }
        let(:inventory_4) { create(:inventory, user: user_1, item: 'ammo', quantity: 12) }

        let(:user_2) { create(:user) }
        let(:inventory_5) { create(:inventory, user: user_2, item: 'water', quantity: 12) }
        let(:inventory_6) { create(:inventory, user: user_2, item: 'food', quantity: 12) }
        let(:inventory_7) { create(:inventory, user: user_2, item: 'medicine', quantity: 12) }
        let(:inventory_8) { create(:inventory, user: user_2, item: 'ammo', quantity: 12) }

        before do
          user_1.reload
          inventory_1.reload
          inventory_2.reload
          inventory_3.reload
          inventory_4.reload
          user_2.reload
          inventory_5.reload
          inventory_6.reload
          inventory_7.reload
          inventory_8.reload


          params = {
            "trade": {
              "user_trader_1": {
                "id": user_1.id,
                "send": {
                  "water": 3,
                  "food": 0,
                  "medicine": 0,
                  "ammo": 0
                }
              },
              "user_trader_2": {
                "id": user_2.id,
                "send": {
                  "water": 0,
                  "food": 0,
                  "medicine": 0,
                  "ammo": 8
                }
              }
            }
          }
          post("/api/v1/trades", params:)
        end

        subject(:res) { JSON.parse(response.body).deep_symbolize_keys }

        it 'expect to has status unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'expect to has the correct error message' do
          expect(res[:message]).to eq('Invalid transaction.')
        end

        it 'expect to inventory of USER 1 has not changed' do
          expect(user_1.amount_of_water.quantity).to eq(12)
          expect(user_1.amount_of_ammo.quantity).to eq(12)
        end

        it 'expect to inventory of USER 2 has not changed' do
          expect(user_2.amount_of_water.quantity).to eq(12)
          expect(user_2.amount_of_ammo.quantity).to eq(12)
        end
      end


      context 'when the user has not the amount of items on inventory' do
        let(:user_1) { create(:user) }
        let(:inventory_1) { create(:inventory, user: user_1, item: 'water', quantity: 12) }
        let(:inventory_2) { create(:inventory, user: user_1, item: 'food', quantity: 12) }
        let(:inventory_3) { create(:inventory, user: user_1, item: 'medicine', quantity: 12) }
        let(:inventory_4) { create(:inventory, user: user_1, item: 'ammo', quantity: 12) }

        let(:user_2) { create(:user) }
        let(:inventory_5) { create(:inventory, user: user_2, item: 'water', quantity: 12) }
        let(:inventory_6) { create(:inventory, user: user_2, item: 'food', quantity: 12) }
        let(:inventory_7) { create(:inventory, user: user_2, item: 'medicine', quantity: 12) }
        let(:inventory_8) { create(:inventory, user: user_2, item: 'ammo', quantity: 12) }

        before do
          user_1.reload
          inventory_1.reload
          inventory_2.reload
          inventory_3.reload
          inventory_4.reload
          user_2.reload
          inventory_5.reload
          inventory_6.reload
          inventory_7.reload
          inventory_8.reload


          params = {
            "trade": {
              "user_trader_1": {
                "id": user_1.id,
                "send": {
                  "water": 10, # 10 x 4 = 40
                  "food": 0,
                  "medicine": 0,
                  "ammo": 3   # 3 X 1 = 3   -> total = 43
                }
              },
              "user_trader_2": {
                "id": user_2.id,
                "send": {
                  "water": 1, # 1 x 4 = 4
                  "food": 13, # 13 X 3 = 39   -. total = 43
                  "medicine": 0,
                  "ammo": 0
                }
              }
            }
          }
          post("/api/v1/trades", params:)
        end

        subject(:res) { JSON.parse(response.body).deep_symbolize_keys }

        it 'expect to has status unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'expect to has the correct error message' do
          expect(res[:message]).to eq('User does not have available resources.')
        end

        it 'expect to inventory of USER 1 has not changed' do
          expect(user_1.amount_of_water.quantity).to eq(12)
          expect(user_1.amount_of_ammo.quantity).to eq(12)
        end

        it 'expect to inventory of USER 2 has not changed' do
          expect(user_2.amount_of_water.quantity).to eq(12)
          expect(user_2.amount_of_ammo.quantity).to eq(12)
        end
      end
    end
  end
end

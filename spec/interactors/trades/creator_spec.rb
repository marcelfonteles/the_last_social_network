require 'rails_helper'

describe Trades::Creator do
  describe '.call' do
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

    context 'when the total of points is sent incorrectly' do
      let(:params) do
        {
          "user_trader_1" => {
            "id" => user_1.id,
            "send" => {
              "water" => 2,
              "food" => 1,
              "medicine" => 0,
              "ammo" => 0
            }
          },
          "user_trader_2" => {
            "id" => user_2.id,
            "send" => {
              "water" => 0,
              "food" => 0,
              "medicine" => 2,
              "ammo" => 4
            }
          }
        }
      end

      subject(:context) { described_class.call(params: params) }

      it 'should be a failure' do
        expect(context).to be_a_failure
      end

      it 'should USER 1 has the correct amount on inventory' do
        user_1.reload
        inventory_1.reload
        inventory_2.reload
        inventory_3.reload
        inventory_4.reload
        context.reload

        expect(user_1.amount_of_water.quantity).to eq(12)
        expect(user_1.amount_of_food.quantity).to eq(12)
        expect(user_1.amount_of_medicine.quantity).to eq(12)
        expect(user_1.amount_of_ammo.quantity).to eq(12)
      end

      it 'should USER 2 has the correct amount on inventory' do
        user_2.reload
        inventory_5.reload
        inventory_6.reload
        inventory_7.reload
        inventory_8.reload
        context.reload

        expect(user_2.amount_of_water.quantity).to eq(12)
        expect(user_2.amount_of_food.quantity).to eq(12)
        expect(user_2.amount_of_medicine.quantity).to eq(12)
        expect(user_2.amount_of_ammo.quantity).to eq(12)
      end
    end

    context 'when some user has not the quantity on inventory' do
      let(:params) do
        {
          "user_trader_1" => {
            "id" => user_1.id,
            "send" => {
              "water" => 0,
              "food" => 0,
              "medicine" => 14, # 28
              "ammo" => 0
            }
          },
          "user_trader_2" => {
            "id" => user_2.id,
            "send" => {
              "water" => 0,
              "food" => 0,
              "medicine" => 10,
              "ammo" => 8
            }
          }
        }
      end

      subject(:context) { described_class.call(params: params) }

      before(:each) do
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
      end

      it 'should be a failure' do
        expect(context).to be_a_failure
      end

      it 'should USER 1 has the correct amount on inventory' do
        expect(user_1.amount_of_water.quantity).to eq(12)
        expect(user_1.amount_of_food.quantity).to eq(12)
        expect(user_1.amount_of_medicine.quantity).to eq(12)
        expect(user_1.amount_of_ammo.quantity).to eq(12)
      end

      it 'should USER 2 has the correct amount on inventory' do
        expect(user_2.amount_of_water.quantity).to eq(12)
        expect(user_2.amount_of_food.quantity).to eq(12)
        expect(user_2.amount_of_medicine.quantity).to eq(12)
        expect(user_2.amount_of_ammo.quantity).to eq(12)
      end
    end

    context 'when some user is infected' do
      let(:user_3) { create(:user, infected: true) }
      let(:inventory_9) { create(:inventory, user: user_2, item: 'water', quantity: 12) }
      let(:inventory_10) { create(:inventory, user: user_2, item: 'food', quantity: 12) }
      let(:inventory_11) { create(:inventory, user: user_2, item: 'medicine', quantity: 12) }
      let(:inventory_12) { create(:inventory, user: user_2, item: 'ammo', quantity: 12) }

      let(:params) do
        {
          "user_trader_1" => {
            "id" => user_1.id,
            "send" => {
              "water" => 2,
              "food" => 0,
              "medicine" => 0,
              "ammo" => 0
            }
          },
          "user_trader_2" => {
            "id" => user_3.id,
            "send" => {
              "water" => 0,
              "food" => 0,
              "medicine" => 2,
              "ammo" => 4
            }
          }
        }
      end

      subject(:context) { described_class.call(params: params) }

      before(:each) do
        user_1.reload
        inventory_1.reload
        inventory_2.reload
        inventory_3.reload
        inventory_4.reload

        user_3.reload
        inventory_9.reload
        inventory_10.reload
        inventory_11.reload
        inventory_12.reload
      end

      it 'should be a failure' do
        expect(context).to be_a_failure
      end

      it 'should USER 1 has the correct amount on inventory' do
        expect(user_1.amount_of_water.quantity).to eq(12)
        expect(user_1.amount_of_food.quantity).to eq(12)
        expect(user_1.amount_of_medicine.quantity).to eq(12)
        expect(user_1.amount_of_ammo.quantity).to eq(12)
      end

      it 'should USER 2 has the correct amount on inventory' do
        expect(user_2.amount_of_water.quantity).to eq(12)
        expect(user_2.amount_of_food.quantity).to eq(12)
        expect(user_2.amount_of_medicine.quantity).to eq(12)
        expect(user_2.amount_of_ammo.quantity).to eq(12)
      end
    end

    context 'when the parameters of transaction is sent correctly' do
      let(:params) do
        {
          "user_trader_1" => {
            "id" => user_1.id,
            "send" => {
              "water" => 2,
              "food" => 0,
              "medicine" => 0,
              "ammo" => 0
            }
          },
          "user_trader_2" => {
            "id" => user_2.id,
            "send" => {
              "water" => 0,
              "food" => 0,
              "medicine" => 2,
              "ammo" => 4
            }
          }
        }
      end

      subject(:context) { described_class.call(params: params) }

      it 'should be a success' do
        expect(context).to be_a_success
      end

      it 'should USER 1 has the correct amount on inventory' do
        user_1.reload
        inventory_1.reload
        inventory_3.reload
        inventory_4.reload
        context.reload

        expect(user_1.amount_of_water.quantity).to eq(10)
        expect(user_1.amount_of_medicine.quantity).to eq(14)
        expect(user_1.amount_of_ammo.quantity).to eq(16)
      end

      it 'should USER 2 has the correct amount on inventory' do
        user_2.reload
        inventory_5.reload
        inventory_7.reload
        inventory_8.reload
        context.reload

        expect(user_2.amount_of_water.quantity).to eq(14)
        expect(user_2.amount_of_medicine.quantity).to eq(10)
        expect(user_2.amount_of_ammo.quantity).to eq(8)
      end
    end
  end


end
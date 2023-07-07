require 'rails_helper'

describe Users::Fetcher do
  describe ".call" do
    let (:user) { create(:user) }
    let(:inventory_1) { create(:inventory, user: user, item: 'water') }
    let(:inventory_2) { create(:inventory, user: user, item: 'food') }
    let(:inventory_3) { create(:inventory, user: user, item: 'medicine') }
    let(:inventory_4) { create(:inventory, user: user, item: 'ammo') }

    subject(:context) { Users::Fetcher.call(user: user) }

    context 'when everything is fine' do
      before do
        user.reload
        inventory_1.reload
        inventory_2.reload
        inventory_3.reload
        inventory_4.reload
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'provides the user' do
        expect(context.user['name']).to eq(user.name)
        expect(context.user['gender']).to eq(user.gender)
        expect(context.user['birthday']).to eq(user.birthday.to_s)
      end

      it 'provides the inventory' do
        expect(context.user['inventories'].size).to eq(4)
      end

      it 'provides one of each inventory item' do
        items = context.user['inventories'].map { |item| item['item'] }
        expect(items).to eq(Inventory.items.keys)
      end
    end
  end
end

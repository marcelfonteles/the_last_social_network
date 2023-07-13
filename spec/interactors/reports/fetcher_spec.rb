require 'rails_helper'

describe Reports::Fetcher do
  describe '.call' do
    context 'when success' do
      before do
        5.times do
          user = create(:user, infected: false)
          create(:inventory, user: user, item: 'water')
          create(:inventory, user: user, item: 'food')
          create(:inventory, user: user, item: 'medicine')
          create(:inventory, user: user, item: 'ammo')
        end

        5.times do
          user = create(:user, infected: true, warning_count: 4)
          create(:inventory, user: user, item: 'water')
          create(:inventory, user: user, item: 'food')
          create(:inventory, user: user, item: 'medicine')
          create(:inventory, user: user, item: 'ammo')
        end
      end

      subject(:context) { described_class.call }

      it 'should be a success' do
        expect(context).to be_a_success
      end

      it 'should have 50% of healthy users' do
        expect(context.reports[:fraction_of_healthy_users]).to eq(0.5)
      end
    end
  end
end
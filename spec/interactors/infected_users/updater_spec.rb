require 'rails_helper'

describe InfectedUsers::Updater do
  describe '.call' do
    context 'when user has ZERO warning' do
      let(:user) { create(:user) }
      subject(:context) { InfectedUsers::Updater.call(user_id: user.id) }

      it 'should be a success' do
        context.reload

        expect(context).to be_a_success
      end

      it 'should increment in ONE the total of warnings' do
        context.reload
        user.reload

        expect(user.warning_count).to eq(1)
      end

      it 'should NOT marked as infected' do
        context.reload
        user.reload

        expect(user.infected).to eq(false)
      end
    end

    context 'when user has TWO warnings' do
      let(:user) { create(:user, warning_count: 2) }
      subject(:context) { InfectedUsers::Updater.call(user_id: user.id) }

      it 'should be a success' do
        context.reload

        expect(context).to be_a_success
      end

      it 'should increment in ONE the total of warnings' do
        context.reload
        user.reload

        expect(user.warning_count).to eq(3)
      end

      it 'should marked as infected' do
        context.reload
        user.reload

        expect(user.infected).to eq(true)
      end
    end

    context 'when user has THREE warnings' do
      let(:user) { create(:user, warning_count: 3) }
      subject(:context) { InfectedUsers::Updater.call(user_id: user.id) }

      it 'should be a success' do
        context.reload

        expect(context).to be_a_success
      end

      it 'should increment in ONE the total of warnings' do
        context.reload
        user.reload

        expect(user.warning_count).to eq(4)
      end

      it 'should REMAIN marked as infected' do
        context.reload
        user.reload

        expect(user.infected).to eq(true)
      end
    end
  end
end

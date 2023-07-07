require 'rails_helper'

describe Users::Creator do
  subject(:context) { Users::Creator.call(params: { "name": "John Doe", "gender": "male", "birthday": "1994-12-05" }) }

  describe ".call" do
    context 'when given the correct parameters' do
      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'provides the user' do
        expect(context.user.name).to eq('John Doe')
        expect(context.user.gender).to eq('male')
        expect(context.user.birthday).to eq(Date.new(1994,12,5))
      end

      it 'provides the inventory' do
        expect(context.inventories.size).to eq(4)
      end

      it 'provides the inventory linked to user' do
        expect(context.user.inventories.size).to eq(4)
      end
    end
  end
end

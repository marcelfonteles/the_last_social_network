require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:item) }
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end

  describe 'enums' do
    it { should define_enum_for(:item) }
    it { should define_enum_for(:item).with_values(%w[water food medicine ammo]) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:user) }
  end
end

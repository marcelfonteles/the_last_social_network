require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:birthday) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_numericality_of(:last_latitude).is_less_than_or_equal_to(90.0) }
    it { is_expected.to validate_numericality_of(:last_latitude).is_greater_than_or_equal_to(0.0) }
    it { is_expected.to validate_numericality_of(:last_longitude).is_less_than_or_equal_to(180.0) }
    it { is_expected.to validate_numericality_of(:last_longitude).is_greater_than_or_equal_to(0.0) }
  end

  describe 'enums' do
    it { should define_enum_for(:gender) }
    it { should define_enum_for(:gender).with_values(%w[male female transgender questioning not_applicable]) }
  end

  # describe 'relationships' do
  #   it { is_expected.to have_many(:inventory_items) }
  # end
end

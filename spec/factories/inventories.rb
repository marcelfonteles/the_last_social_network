FactoryBot.define do
  factory :inventory do
    association :user
    item { 'water' }
    quantity { 5 }
  end
end

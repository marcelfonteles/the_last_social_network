FactoryBot.define do
  factory :user do
    name { FFaker::NameBR.name }
    birthday {  FFaker::Time.date }
    gender { 'male' }
  end
end
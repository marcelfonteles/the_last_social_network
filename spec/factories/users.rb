FactoryBot.define do
  factory :user do
    name { FFaker::NameBR.name }
    birthday {  FFaker::Time.date }
    gender { 'male' }
    infected { false }
    warning_count { 0 }
  end
end
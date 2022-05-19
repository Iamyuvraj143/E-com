FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'welcome' }
    password_confirmation { 'welcome' }
  end
end
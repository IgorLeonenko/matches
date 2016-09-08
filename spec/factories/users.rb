FactoryGirl.define do
  factory :user do
    name 'FirstUser'
    sequence(:username) { |n| "foo#{n}" }
    email { "#{username}@example.com" }
    password 'secret'
    avatar ''
  end
end

FactoryGirl.define do
  factory :user do
    name 'FirstUser'
    sequence(:username) { |n| "foo#{n}" }
    email { "#{username}@example.com" }
    password 'secret'
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'user_avatar.jpg')) }
  end
end

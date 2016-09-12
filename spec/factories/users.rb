FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name }
    username { Faker::Internet.user_name }
    email    { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    avatar   { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'user_avatar.jpg')) }
  end
end

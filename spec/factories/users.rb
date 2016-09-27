FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name }
    username { Faker::Internet.user_name(5..20) }
    email    { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    avatar   { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'user_avatar.jpg')) }
  end

  trait :admin do
    admin true
  end
end

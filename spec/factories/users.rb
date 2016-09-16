FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name }
    username { Faker::Internet.user_name(5..20) }
    email    { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    avatar   { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'user_avatar.jpg')) }
  end

  factory :user_admin do
    name     'admin'
    username 'superuser'
    email    'admin@mail.com'
    password 'admin123456'
    admin    true
  end
end

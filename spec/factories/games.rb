FactoryGirl.define do
  factory :game do
    name  { Faker::Lorem.word }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'icon.png')) }
  end
end

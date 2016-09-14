FactoryGirl.define do
  factory :game do
    name  { Faker::Lorem.characters(10) }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'icon.png')) }
  end
end

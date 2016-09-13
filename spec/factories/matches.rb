FactoryGirl.define do
  factory :match do
    name { Faker::Lorem.characters(10) }
    game { create(:game) }
  end
end

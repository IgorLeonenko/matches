FactoryGirl.define do
  factory :match do
    game_name { Faker::Team.name }
  end
end

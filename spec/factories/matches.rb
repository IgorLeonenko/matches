FactoryGirl.define do
  factory :match do
    sequence(:game_name) { |n| "football-#{n}" }
  end
end

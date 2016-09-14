FactoryGirl.define do
  factory :match do
    name   { Faker::Lorem.characters(10) }
    game   { create(:game) }
    status 'prepare'
    home_team_score 0
    invited_team_score 0
  end
end

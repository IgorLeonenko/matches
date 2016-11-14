FactoryGirl.define do
  factory :match do
    game { create(:game) }
    game_id { game.id }
    status "prepare"
    home_team_score 0
    invited_team_score 0
  end
end

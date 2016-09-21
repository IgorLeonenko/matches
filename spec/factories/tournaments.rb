FactoryGirl.define do
  factory :tournament do
    title { Faker::Company.name }
    description "Great Tournament"
    start_date "2016-09-16 17:01:07"
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'icon.png')) }
    style "league"
    state "open"
    game { create(:game) }
    game_id { game.id }
    teams_quantity 2
    players_in_team 2
  end
end

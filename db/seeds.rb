# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.delete_all
Team.delete_all
TeamsUser.delete_all
Match.delete_all


4.times do |i|
  User.create(name: "user-#{i}", email: "example-#{i}@mail.com", password: '123456', password_confirmation: '123456', username: "player-#{i}")
end

4.times do |i|
  Team.create(name: "team-#{i}")
end

2.times do |i|
  Match.create(game_name: "team_game-#{i}")
end

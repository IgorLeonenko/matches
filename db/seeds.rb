User.destroy_all
Team.destroy_all
TeamUser.destroy_all
Match.destroy_all
Game.destroy_all

names       = %w(jack jan den rob)
user_names  = %w(warrior guitarman flash rubyist)
team_names  = %w(winners assassins bears eagles)
game_names  = %w(fighting nascar wargame pool)
users       = []
teams       = []
games       = []

4.times do |i|
  users << User.create(name: "#{names[i-1]}", email: "example-#{user_names[i-1]}@mail.com",
                       password: '123456', password_confirmation: '123456', username: "#{user_names[i-1]}")
end

User.create(name: 'admin', email: 'admin@mail.com', password: 'admin123456',
            password_confirmation: 'admin123456', username: 'superuser', admin: true)

4.times do |i|
  teams << Team.create(name: "#{team_names[i-1]}")
end

teams[0].users << users[0]
teams[0].users << users[1]
teams[1].users << users[2]
teams[1].users << users[3]
teams[2].users << users[1]
teams[2].users << users[0]
teams[3].users << users[2]
teams[3].users << users[3]

4.times do |i|
  games << Game.create(name: "#{game_names[i-1]}")
end

Match.create(name: 'fighting', home_team: teams[0], invited_team: teams[1], game: games[0])
Match.create(name: 'football', home_team: teams[1], invited_team: teams[2], game: games[1])
Match.create(name: 'billiard', home_team: teams[3], invited_team: teams[0], game: games[2])
Match.create(name: 'guitar_battle', home_team: teams[2], invited_team: teams[3], game: games[3])

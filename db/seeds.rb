TournamentUser.destroy_all
TeamUser.destroy_all
User.destroy_all
Team.destroy_all
Match.destroy_all
Tournament.destroy_all
Game.destroy_all

names       = %w(jack jan den rob)
user_names  = %w(warrior guitarman flash rubyist)
team_names  = %w(winners assassins)
game_names  = %w(fighting nascar wargame pool)
users       = []
teams       = []
games       = []
tournaments = []

4.times do |i|
  users << User.create(name: "#{names[i-1]}", email: "example-#{user_names[i-1]}@mail.com",
                       password: '123456', password_confirmation: '123456', username: "#{user_names[i-1]}")
end

User.create(name: 'admin', email: 'admin@mail.com', password: 'admin123456',
            password_confirmation: 'admin123456', username: 'superuser', admin: true)

4.times do |i|
  games << Game.create(name: "#{game_names[i-1]}")
end

2.times do |i|
  tournaments << Tournament.create(title: "test_tournament_#{i}", description: 'some description', start_date: '2016-09-28 00:00:00',
                    style: 'league', state: 'open', game_id: games[0].id, creator_id: 1, picture: '', teams_quantity: 2)
end

tournaments[0].users << users[0]
tournaments[0].users << users[1]
tournaments[1].users << users[2]
tournaments[1].users << users[3]

2.times do |i|
  teams << Team.create(name: "#{team_names[i-1]}", tournament_id: "#{i+1}")
end

teams[0].users << users[0]
teams[0].users << users[1]
teams[1].users << users[2]
teams[1].users << users[3]

Match.create(home_team: teams[0], invited_team: teams[1], game: games[0])
Match.create(home_team: teams[1], invited_team: teams[0], game: games[1])

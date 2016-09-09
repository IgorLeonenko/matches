User.destroy_all
Team.destroy_all
TeamsUser.destroy_all
Match.destroy_all

user_names = ['jack', 'jan', 'den', 'rob']
users      = []
teams      = []

4.times do |i|
  users << User.create(name: "user-#{user_names[i-1]}", email: "example-#{user_names[i-1]}@mail.com",
                       password: '123456', password_confirmation: '123456', username: "player-#{i}")
end

4.times do |i|
  teams << Team.create(name: "team-#{i}")
end

teams[0].users << users[0]
teams[0].users << users[1]
teams[1].users << users[2]
teams[1].users << users[3]
teams[2].users << users[3]
teams[2].users << users[1]
teams[3].users << users[2]
teams[3].users << users[0]

Match.create(game_name: 'fighting', home_team: teams[0], invited_team: teams[1])
Match.create(game_name: 'football', home_team: teams[2], invited_team: teams[1])
Match.create(game_name: 'billiard', home_team: teams[3], invited_team: teams[0])
Match.create(game_name: 'guitar_battle', home_team: teams[2], invited_team: teams[3])

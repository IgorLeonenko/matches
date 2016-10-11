class TournamentWorker
  include Sidekiq::Worker

  def perform(tournament_id)
    tournament = Tournament.find(tournament_id)
    tournament.update_attribute(:state, 'started')
    schedule_matches(tournament)
  end

  def schedule_matches(tournament)
    # deathmatch
    teams = tournament.teams
    rounds_number = Math.log2(teams.size).ceil
    rounds = []
    rounds_number.times do |r|
      rounds << tournament.rounds.create(number: r)
    end
    if Math.log2(teams.size) % 1 == 0
      teams.sample(teams.size).each_slice(2) do |team_ary|
        rounds[0].matches.create(status: 'prepare', style: 'tournament',
                                 home_team: team_ary[0],
                                 invited_team: team_ary[1],
                                 game: tournament.game)

      end
    else
      numbers = teams.size - (2**Math.log2(teams.size).floor)
      teams.sample(numbers * 2).each_slice(2) do |team_ary|
        rounds[0].matches.create(status: 'prepare', style: 'tournament',
                                 home_team: team_ary[0],
                                 invited_team: team_ary[1],
                                 game: tournament.game)
      end
    end
  end
end

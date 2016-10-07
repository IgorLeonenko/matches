class TournamentWorker
  include Sidekiq::Worker

  def perform(tournament_id)
    tournament = Tournament.find(tournament_id)
    if tournament.can_be_started? && tournament.state == 'open'
      tournament.update_attribute(:state, 'started')
      schedule_matches(tournament)
    end
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
      (teams.size / 2).times do
        rounds[0].matches.create(status: 'prepare', style: 'tournament',
                                 home_team: teams.sample(1)[0],
                                 invited_team: teams.sample(1)[0],
                                 game: tournament.game)
      end
    end
  end
end

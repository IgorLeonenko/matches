class MatchWorker
  include Sidekiq::Worker

  def perform(tournament_id)
    tournament = Tournament.find(tournament_id)
    rounds = tournament.rounds
    teams = []
    rounds.each do |round|
      if round.finished
        round.matches.each{|match| teams << match.winner_team}
        teams.sample(teams.size).each_slice(2) do |team_ary|
          rounds.where('number > ?', round.number).first.matches.create(status: 'prepare', style: 'tournament',
                                   home_team: team_ary[0],
                                   invited_team: team_ary[1],
                                   game: tournament.game)
        end
      end
    end
  end

end

class MatchWorker
  include Sidekiq::Worker

  def perform(tournament_id)
    tournament = Tournament.find(tournament_id)
    schedule_next_match(tournament)
  end


  private

  def schedule_next_match(tournament)
    rounds = tournament.rounds
    teams = []
    auto_winners = []
    tournament.teams.each do |team|
      unless team.in_first_round?(tournament.rounds.first) || tournament.rounds.first.next.check_teams(team.id)
        auto_winners << team
      end
    end
    rounds.each do |round|
      round.matches.where(status: 'played').each do |match|
        unless round.next.check_teams(match.winner_team.id)
          teams += auto_winners
          teams << match.winner_team
          teams.each_slice(2) do |team_ary|
            round.next.matches.create(status: 'prepare', style: 'tournament',
                                      home_team: team_ary[0],
                                      invited_team: team_ary[1],
                                      game: tournament.game)
          end
        end
      end
    end
  end
end

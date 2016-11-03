class TournamentsRepresenter
  def initialize(tournaments)
    @tournaments = tournaments
  end

  def basic
    @tournaments.map { |tournament| TournamentRepresenter.new(tournament).basic }
  end

  def with_teams
    @tournaments.map { |tournament| TournamentRepresenter.new(tournament).with_teams }
  end

  def with_teams_and_users
    @tournaments.map { |tournament| TournamentRepresenter.new(tournament).with_teams_and_users }
  end
end

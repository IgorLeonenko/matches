class TournamentRepresenter < BaseRepresenter
  def initialize(tournament)
    @tournament = tournament
  end

  def basic
    {
      id: @tournament.id,
      title: @tournament.title,
      description: @tournament.description,
      style: @tournament.style,
      state: @tournament.state,
      start_date: @tournament.start_date.strftime("%F"),
      teams_quantity: @tournament.teams_quantity,
      players_in_team: @tournament.players_in_team,
      game_id: @tournament.game_id,
    }
  end

  def with_teams
    basic.megre(
      teams: TeamsRepresenter.new(@tournament.teams).basic,
    )
  end

  def with_teams_and_users
    basic.merge(
      teams: TeamsRepresenter.new(@tournament.teams).with_users,
    )
  end

  def with_all
    with_teams_and_users.merge(
      rounds: RoundsRepresenter.new(@tournament.rounds).with_matches,
    )
  end
end

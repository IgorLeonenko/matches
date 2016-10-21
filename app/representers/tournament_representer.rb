<<<<<<< HEAD
class TournamentRepresenter < BaseRepresenter
=======
class TournamentRepresenter
>>>>>>> add representer for round & change representer for tournament
  def initialize(tournament)
    @tournament = tournament
  end

<<<<<<< HEAD
  def basic
    {
      id: @tournament.id,
      title: @tournament.title,
      description: @tournament.description,
      style: @tournament.style,
      state: @tournament.state,
      start_date: @tournament.start_date,
      teams_quantity: @tournament.teams_quantity,
      players_in_team: @tournament.players_in_team,
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
=======
  def as_json(_ = {})
    {
        id: @tournament.id,
        title: @tournament.title,
        description: @tournament.description,
        style: @tournament.style,
        state: @tournament.state,
        start_date: @tournament.start_date,
        teams_quantity: @tournament.teams_quantity,
        teams_size: @tournament.teams.size,
        players_in_team: @tournament.players_in_team,
        teams: TeamsRepresenter.new(@tournament.teams),
        rounds: RoundsRepresenter.new(@tournament.rounds)
      }
>>>>>>> add representer for round & change representer for tournament
  end
end

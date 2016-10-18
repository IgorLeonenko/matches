class TournamentRepresenter
  def initialize(tournament)
    @tournament = tournament
  end

  def as_json(_ = {})
    {
        id: @tournament.id,
        title: @tournament.title,
        description: @tournament.description,
        style: @tournament.style,
        state: @tournament.state,
        start_date: @tournament.start_date,
        teams_quantity: @tournament.teams_quantity,
        players_in_team: @tournament.players_in_team,
        teams: TeamsRepresenter.new(@tournament.teams)
      }
  end
end
class TournamentsRepresenter
  def initialize(tournaments)
    @tournaments = tournaments
  end

  def as_json(_ = {})
    @tournaments.map do |t|
      {
        id: t.id,
        title: t.title,
        description: t.description,
        style: t.style,
        state: t.state,
        start_date: t.start_date,
        teams_quantity: t.teams_quantity,
        players_in_team: t.players_in_team
      }
    end
  end
end
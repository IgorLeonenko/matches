class MatchesRepresenter
  def initialize(matches)
    @matches = matches
  end

  def as_json(_ = {})
    @matches.map do |match|
      {
        id: match.id,
        style: match.style,
        game: match.game.name,
        status: match.status,
        home_team_name: match.home_team.name,
        home_team_score: match.home_team_score,
        invited_team_name: match.invited_team.name,
        invited_team_score: match.invited_team_score        
      }
    end
  end
end
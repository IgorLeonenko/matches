class MatchRepresenter
  def initialize(match)
    @match = match
  end

  def as_json(_ = {})
    {
      style: @match.style,
      game: @match.game.name,
      status: @match.status,
      home_team: TeamRepresenter.new(@match.home_team), 
      home_team_score: @match.home_team_score,
      invited_team: TeamRepresenter.new(@match.invited_team),
      invited_team_score: @match.invited_team_score        
    }
  end
end
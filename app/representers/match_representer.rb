class MatchRepresenter < BaseRepresenter
  def initialize(match)
    @match = match
  end

  def basic
    {
      id: @match.id,
      style: @match.style,
      game: @match.game.name,
      status: @match.status,
    }
  end

  def with_teams
    basic.merge(
      home_team: TeamRepresenter.new(@match.home_team).with_users,
      home_team_score: @match.home_team_score,
      invited_team: TeamRepresenter.new(@match.invited_team).with_users,
      invited_team_score: @match.invited_team_score,
    )
  end
end

class RoundRepresenter < BaseRepresenter
  def initialize(round)
    @round = round
  end

  def basic
    {
      id: @round.id,
      number: @round.number,
      tournament_id: @round.tournament_id,
    }
  end

  def with_matches
    basic.merge(
      matches: MatchesRepresenter.new(@round.matches).with_teams
    )
  end
end

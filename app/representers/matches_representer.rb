class MatchesRepresenter < BaseRepresenter
  def initialize(matches)
    @matches = matches
  end

  def basic
    @matches.map { |match| MatchRepresenter.new(match).basic }
  end

  def with_teams
    @matches.map { |match| MatchRepresenter.new(match).with_teams }
  end
end

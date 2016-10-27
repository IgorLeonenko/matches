class RoundsRepresenter < BaseRepresenter
  def initialize(rounds)
    @rounds = rounds
  end

  def basic
    @rounds.map { |round| RoundRepresenter.new(round).basic }
  end

  def with_matches
    @rounds.map { |round| RoundRepresenter.new(round).with_matches }
  end
end

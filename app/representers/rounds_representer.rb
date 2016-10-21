<<<<<<< HEAD
class RoundsRepresenter < BaseRepresenter
=======
class RoundsRepresenter
>>>>>>> add representer for round & change representer for tournament
  def initialize(rounds)
    @rounds = rounds
  end

<<<<<<< HEAD
  def basic
    @rounds.map { |round| RoundRepresenter.new(round).basic }
  end

  def with_matches
    @rounds.map { |round| RoundRepresenter.new(round).with_matches }
=======
  def as_json(_ = {})
    @rounds.map do |r|
      {
        id: r.id,
        number: r.number,
        matches: MatchesRepresenter.new(r.matches)
      }
    end
>>>>>>> add representer for round & change representer for tournament
  end
end

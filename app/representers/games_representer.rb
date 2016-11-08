class GamesRepresenter < BaseRepresenter
  def initialize(games)
    @games = games
  end

  def basic
    @games.map { |game| GameRepresenter.new(game).basic }
  end
end

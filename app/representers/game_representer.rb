class GameRepresenter < BaseRepresenter
  def initialize(game)
    @game = game
  end

  def basic
    {
      id: @game.id,
      name: @game.name,
    }
  end
end

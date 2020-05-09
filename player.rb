
class Player
  attr_reader :game, :name

  def initialize(game, name)
    @game = game
    @name = name
  end
end
class ServerZombieTurn
  include State
  
  def initialize(game)
    @game = game
  end
end
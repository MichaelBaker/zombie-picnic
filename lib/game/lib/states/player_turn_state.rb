class ServerPlayerTurnState
  include State
  
  def initialize(game)
    @game = game
  end
  
  def handle_message(message)
  end
end

class ClientPlayerTurnState
  def initialize(game , player)
    @game = game
    
    @game.add_widget TextWidget.new("It's #{player.name}'s turn!" , id: "status text")
  end
  
  def button_down(id)
    
  end
end
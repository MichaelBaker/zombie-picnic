class ClientPlayerTurnState
  include State
  
  attr_reader :player
  
  def initialize(game , player)
    @game   = game
    
    @player = player
    @player.reset_movement_points
    
    @game.add_widget TextWidget.new("It's #{player.name}'s turn!" , id: "status text")
  end
  
  def button_down(id)
    @game.network.send_tcp_message MovePlayerRight.new
  end
end

class ClientPlayerTurnState
  include State
  
  attr_reader :player
  
  def initialize(game , player)
    @game   = game
    
    @player = player
    @player.reset_movement_points
    
    @game.add_widget TextWidget.new("It's #{player.name}'s turn!" , id: "status text")
  end
  
  handle YourTurn do
    player = @game.entities.find_player_by_client_id message.client_id
    @game.change_state YourTurnState , @game , player
  end
  
  handle StartPlayerTurn do
    player = @game.entities.find_player_by_client_id message.client_id
    @game.change_state ClientPlayerTurnState , @game , player
  end
  
  def button_down(id)
    @game.network.send_tcp_message MovePlayerRight.new
  end
end

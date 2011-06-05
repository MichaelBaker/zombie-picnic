class YourTurnState
  include State
  
  attr_reader :player
  
  def initialize(game , player)
    @game = game
    
    @game.add_widget TextWidget.new("It's your turn!" , id: "status text")
    
    @player = player
    @player.reset_movement_points
  end
  
  def button_down(id)
    case id
    when KbEnter , KbReturn
      @game.network.send_tcp_message EndTurn.new
    when KbLeft
      @game.network.send_tcp_message MovePlayerLeft.new
    when KbRight
      @game.network.send_tcp_message MovePlayerRight.new
    when KbUp
      @game.network.send_tcp_message MovePlayerUp.new
    when KbDown
      @game.network.send_tcp_message MovePlayerDown.new
    end
  end
  
  handle YourTurn do
    player = @game.entities.find_player_by_client_id message.client_id
    @game.change_state YourTurnState , @game , player
  end
  
  handle StartPlayerTurn do
    player = @game.entities.find_player_by_client_id message.client_id
    @game.change_state ClientPlayerTurnState , @game , player
  end
end
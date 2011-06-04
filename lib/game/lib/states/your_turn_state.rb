class YourTurnState
  include State
  
  attr_reader :player
  
  def initialize(game , player)
    @game = game
    
    @game.add_widget TextWidget.new("It's your turn!" , id: "status text")
    
    @player = player
  end
  
  def button_down(id)
    case id
    when KbEnter , KbReturn
      @game.network.send_tcp_message EndTurn.new
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
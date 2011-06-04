class ServerPlayerTurnState
  include State
  
  def initialize(game , player)
    @game   = game
    @player = player
  end
  
  handle EndTurn do
    if message.client_id == @game.current_turn_client_id
      @game.advance_turn
      @game.change_state ServerPlayerTurnState , @game , @game.current_player
    end
  end
  
  def button_down(id)
  end
end

class ClientPlayerTurnState
  include State
  
  attr_reader :player
  
  def initialize(game , player)
    @game   = game
    @player = player
    @game.add_widget TextWidget.new("It's #{player.name}'s turn!" , id: "status text")
  end
  
  def button_down(id)
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

module StateManagement
  def change_state(state_class , *args)
    @state = state_class.new(*args)
  end
  
  def current_turn_client_id
    @turn_order[@turn]
  end
  
  def initialize_turn_order
    @turn_order = @entities.players.map(&:client_id).shuffle
    @turn_order << :zombies
    @turn       = 0
  end
  
  def zombie_turn?
    @turn_order[@turn] == :zombies
  end
  
  def advance_turn
    @turn = (@turn + 1) % @turn_order.size
    
    if zombie_turn?
      initiate_zombie_turn
    else
      initiate_player_turn
    end
  end
  
  def initiate_zombie_turn
    puts "Zombie Turn!"
    advance_turn
  end
  
  def initiate_player_turn
    change_state ServerPlayerTurnState , self , current_player
    
    @network.send_tcp_message_to            current_turn_client_id , YourTurn.new(client_id: current_turn_client_id)
    @network.send_tcp_message_to_all_except current_turn_client_id , StartPlayerTurn.new(client_id: current_turn_client_id)
  end
end
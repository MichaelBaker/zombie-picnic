class ServerPlayerTurnState
  include State
  
  def initialize(game , player)
    @game   = game
    @player = player
    
    @game.entities.players.each do |player|
      player.reset_movement_points
      @game.network.broadcast_tcp_message UpdateEntityAttribute.new(player , :movement_points)
    end
  end
  
  def update_player
    @game.network.broadcast_tcp_message UpdateEntityAttribute.new(@player , :position)
    @game.network.broadcast_tcp_message UpdateEntityAttribute.new(@player , :movement_points)
  end
  
  def can_move_to?(player , tile)
    tile && @game.map.reachable_tiles(@player).include?(tile)
  end
  
  def move_player(direction)
    starting_tile    = @game.map.tile_at @player.position
    destination_tile = @game.map.tile_at @player.position.send direction
    
    if can_move_to? @player , destination_tile
      @player.send "move_#{direction}" , starting_tile
      update_player
    end
  end
  
  verify do
    message.client_id == @game.current_turn_client_id
  end
  
  handle EndTurn do
    @game.advance_turn
  end
  
  handle MovePlayerDown do
    move_player :down
  end
  
  handle MovePlayerUp do
    move_player :up
  end
  
  handle MovePlayerLeft do
    move_player :left
  end
  
  handle MovePlayerRight do
    move_player :right
  end
end

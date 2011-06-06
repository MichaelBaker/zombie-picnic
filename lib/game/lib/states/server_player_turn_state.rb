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
  
  verify do
    message.client_id == @game.current_turn_client_id
  end
  
  handle EndTurn do
    @game.advance_turn
  end
  
  handle MovePlayerDown do
    starting_tile    = @game.map.tile_at @player.position
    destination_tile = @game.map.tile_at @player.position.down
    
    if can_move_to? @player , destination_tile
      @player.move_down starting_tile
      update_player
    end
  end
  
  handle MovePlayerUp do
    starting_tile    = @game.map.tile_at @player.position
    destination_tile = @game.map.tile_at @player.position.up
    
    if can_move_to? @player , destination_tile
      @player.move_up starting_tile
      update_player
    end
  end
  
  handle MovePlayerLeft do
    starting_tile    = @game.map.tile_at @player.position
    destination_tile = @game.map.tile_at @player.position.left
    
    if can_move_to? @player , destination_tile
      @player.move_left starting_tile
      update_player
    end
  end
  
  handle MovePlayerRight do
    starting_tile    = @game.map.tile_at @player.position
    destination_tile = @game.map.tile_at @player.position.right
    
    if can_move_to? @player , destination_tile
      @player.move_right starting_tile
      update_player
    end
  end
  
  def update_player
    @game.network.broadcast_tcp_message UpdateEntityAttribute.new(@player , :position)
    @game.network.broadcast_tcp_message UpdateEntityAttribute.new(@player , :movement_points)
  end
  
  def can_move_to?(player , tile)
    tile && @game.map.reachable_tiles(@player).include?(tile)
  end
end

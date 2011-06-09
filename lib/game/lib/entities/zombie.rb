module Zombie
  def can_move?(map)
    @movement_points > 0 && !map.reachable_tiles(self).empty?
  end

  def move(players , map)
    original_position = @position
    @position         = choose_destination closest_player(players) , possible_moves(map)
    @movement_points -= map.tile_at(original_position).speed_modifier
  end
  
  def reset_movement_points
    @movement_points = @speed
  end
  
private

  def choose_destination(player , choices)
    choices.min do |a , b|
      player.position.distance_to(a) <=> player.position.distance_to(b)
    end
  end
  
  def possible_moves(map)
    adjacent_tiles = map.adjacent_tiles(self) - map.entity_tiles
    (adjacent_tiles << map.tile_at(@position)).map &:position
  end
  
  def closest_player(players)
    players.min do |a , b|
      @position.distance_to(a.position) <=> @position.distance_to(b.position)
    end
  end
end

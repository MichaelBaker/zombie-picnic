module Zombie
  def self.included(base_class)
    base_class.send :include , Entity
  end
  
  def can_move?(map)
    @movement_points > 0 && !reachable_tiles(map).empty?
  end
  
  def reachable_tiles(map)
    map.reachable_tiles(self).select do |tile|
      reachable? tile
    end
  end

  def reachable?(tile)
    !tile.kind_of? BaseWaterTile
  end
  
  def move(entities , map)
    original_position = @position
    @position         = choose_destination entities.closest_player(@position) , possible_moves(entities , map)
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
  
  def possible_moves(entities , map)
    adjacent_tiles = map.adjacent_tiles(self).select do |tile|
      reachable?(tile) && !entities.entity_at?(tile.position)
    end
    
    (adjacent_tiles << map.tile_at(@position)).map &:position
  end
end

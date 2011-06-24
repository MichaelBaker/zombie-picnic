class MapTile
  attr_reader :type , :image , :position , :speed_modifier
  
  def initialize(position)
    @position = position
  end
end

class BaseMap
  attr_reader :tiles , :map_hash
  
  def initialize(map_hash , game)
    @map_hash = map_hash
    @game     = game
    @start_x  = -1
    @start_y  = 0
    @walls    = Hash.new {|hash , key| hash[key] = Array.new}
    
    @tiles = map_hash.inject Hash.new do |hash , info|
      tile_class = Kernel.const_get "Base#{info[:type].constantize}Tile"
      position   = Vector.new info[:x] , info[:y]
      
      info[:walls].each do |wall|
        wall_class = Kernel.const_get "Base#{wall[:type].constantize}"
        @walls[{x: position.x , y: position.y}] << wall_class.new(position , wall[:direction])
      end if info[:walls]
      
      hash[{x: position.x , y: position.y}] = tile_class.new(position)
      hash
    end
    
    @width  = @tiles.keys.map {|t| t[:x]}.max + 1
    @height = @tiles.keys.map {|t| t[:y]}.max + 1
  end
  
  def find_viewable_tiles(entity)
    tiles_viewable_from entity.position , entity.sight_range
  end
  
  def tiles_viewable_from(position , range)
    starting_tile = tile_at position
    return [] if range == 0
    
    tiles = [starting_tile]
    
    adjacent_tiles(starting_tile).each do |tile|
      tiles << tile
      tiles.concat tiles_viewable_from(tile.position , range - 1)
    end
    
    tiles.uniq
  end
  
  def right_wall_at?(position)
    wall_with_direction_at? position , :right
  end
  
  def down_wall_at?(position)
    wall_with_direction_at? position , :down
  end
  
  def left_wall_at?(position)
    wall_with_direction_at? position , :left
  end
  
  def up_wall_at?(position)
    wall_with_direction_at? position , :up
  end
  
  def wall_with_direction_at?(position , direction)
    walls = walls_at x: position.x , y: position.y
    walls.any? {|wall| wall.direction == direction}
  end
  
  def walls_at(position)
    @walls[position]
  end
      
  def walls
    @walls.values
  end
  
  def tiles
    @tiles.values
  end
  
  def tiles_in_range(position , distance)
    distances = ((-distance + 1)...distance).to_a
    
    vectors = distances.product(distances).select do |vector|
      (vector[0].abs + vector[1].abs) < distance
    end
    
    vectors.map do |vector|
      @tiles[{x: position.x + vector[0] , y: position.y + vector[1]}]
    end.uniq
  end
  
  def next_starting_position
    Vector.new @start_x += 1 , @start_y
  end
  
  def next_zombie_position
    position = Vector.new (rand * 100).to_i % @width , (rand * 100).to_i % @height
    valid_zombie_position?(position) ? position : next_zombie_position
  end
  
  def valid_zombie_position?(position)
    tile = tile_at position
    !tile.kind_of?(BaseWaterTile) && !@game.entities.entity_at?(position)
  end
  
  def reachable_tiles(entity)
    tiles_reachable_from entity.position , entity.movement_points
  end

  def tile_at(position)
    @tiles[{x: position.x , y: position.y}]
  end
  
  def adjacent_tiles(tile)
    tiles = [tile.position.up , tile.position.down , tile.position.right , tile.position.left].map do |new_position|
      tile_at new_position
    end
    tiles.delete nil
    tiles
  end
  
  def entity_tiles
    @game.entities.map do |entity|
      tile_at entity.position
    end
  end
  
  def blocked_by_wall?(origin , destination)
    if destination.x == origin.left.x && (right_wall_at?(destination) || left_wall_at?(origin))
      return true
    end
    
    if destination.x == origin.right.x && (left_wall_at?(destination) || right_wall_at?(origin))
      return true
    end
    
    if destination.y == origin.up.y && (down_wall_at?(destination) || up_wall_at?(origin))
      return true
    end
    
    if destination.y == origin.down.y && (up_wall_at?(destination) || down_wall_at?(origin))
      return true
    end
    
    return false
  end
  
private

  def tiles_reachable_from(position , speed)
    starting_tile = tile_at position
    return [] if starting_tile.nil? || speed - starting_tile.speed_modifier < 1
    
    adjacent_tiles = adjacent_tiles(starting_tile).select do |tile|
      !@game.entities.entity_at?(tile.position) && !blocked_by_wall?(starting_tile.position , tile.position)
    end
    
    adjacent_tiles.map do |tile|
      tiles_reachable_from tile.position , speed - starting_tile.speed_modifier
    end.concat(adjacent_tiles).flatten.uniq
  end
end

class ClientMap < BaseMap
  def initialize(map_hash , game)
    @game  = game
    @walls = Hash.new {|hash , key| hash[key] = Array.new}
    
    @tiles = map_hash.inject Hash.new do |hash , info|
      tile_class = Kernel.const_get "Client#{info[:type].capitalize}Tile"
      position   = Vector.new info[:x] , info[:y]
      
      info[:walls].each do |wall|
        wall_class = Kernel.const_get "Client#{wall[:type].constantize}"
        @walls[{x: position.x , y: position.y}] << wall_class.new(position , wall[:direction])
      end if info[:walls]
      
      hash[{x: position.x , y: position.y}] = tile_class.new(position)
      hash
    end
    
    @width  = @tiles.keys.map {|t| t[:x]}.max + 1
    @height = @tiles.keys.map {|t| t[:y]}.max + 1
  end
end

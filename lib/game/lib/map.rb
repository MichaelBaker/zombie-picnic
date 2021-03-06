class MapTile
  attr_reader :type , :image , :position , :speed_modifier
  
  def initialize(position)
    @position = position
  end
end

class BaseMap
  include FieldOfView
  
  attr_reader :tiles , :map_hash , :walls , :dimensions , :edge_vectors
  
  def initialize(map_hash , game)
    @map_hash     = map_hash
    @game         = game
    @start_x      = -1
    @start_y      = 0
    
    @width  = map_hash[:dimensions][:x]
    @height = map_hash[:dimensions][:y]
    
    @tiles = map_hash[:tiles].inject Hash.new do |hash , info|
      tile_class = Kernel.const_get "Base#{info[:type].constantize}Tile"
      position   = Vector.new info[:x] , info[:y]
      hash[{x: position.x , y: position.y}] = tile_class.new(position)
      hash
    end
    
    @walls = map_hash[:walls].inject Walls.new do |walls , info|
      wall_class = Kernel.const_get "Base#{info[:type].constantize}"
      walls.add wall_class.new(info)
      walls
    end
    
    find_edge_vectors
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
    @walls.between? origin , destination
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
  
  def find_edge_vectors
    @edge_vectors = Array.new
    
    [-1 , @width].each do |x|
      (-1..@height).each do |y|
        @edge_vectors << Vector.new(x , y)
      end
    end
    
    [-1 , @height].each do |y|
      (-1..@width).each do |x|
        @edge_vectors << Vector.new(x , y)
      end
    end
  end
end

class ClientMap < BaseMap
  def initialize(map_hash , game)
    @game  = game
    
    @width  = map_hash[:dimensions][:x]
    @height = map_hash[:dimensions][:y]
    
    @tiles = map_hash[:tiles].inject Hash.new do |hash , info|
      tile_class = Kernel.const_get "Client#{info[:type].capitalize}Tile"
      position   = Vector.new info[:x] , info[:y]
      hash[{x: position.x , y: position.y}] = tile_class.new(position)
      hash
    end
    
    @walls = map_hash[:walls].inject Walls.new do |walls , info|
      wall_class = Kernel.const_get "Client#{info[:type].constantize}"
      walls.add wall_class.new(info)
      walls
    end
    
    find_edge_vectors
  end
end

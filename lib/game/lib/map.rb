class MapTile
  attr_reader :type , :image , :position , :speed_modifier
  
  def initialize(position)
    @position = position
  end
end

class BaseMap
  attr_reader :tiles , :original_tiles
  
  def initialize(tiles , game)
    @original_tiles = tiles
    @game           = game
    @start_x        = -1
    @start_y        = 0
    
    @tiles = tiles.inject Hash.new do |hash , info|
      tile_class = Kernel.const_get "Base#{info[:type].capitalize}Tile"
      position   = Vector.new info[:x] , info[:y]
      
      hash[{x: position.x , y: position.y}] = tile_class.new(position)
      hash
    end
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
  
  def reachable_tiles(entity)
    tiles_reachable_from entity.position , entity.speed
  end

private

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
  
  def tiles_reachable_from(position , speed)
    starting_tile = tile_at position
    return [] if starting_tile.nil? || speed - starting_tile.speed_modifier < 1
    
    adjacent_tiles(starting_tile).map do |tile|
      if !@game.entities.entity_at?(tile.position)
        tiles_reachable_from tile.position , speed - starting_tile.speed_modifier
      else
        []
      end
    end.concat(adjacent_tiles(starting_tile)).flatten.uniq
  end
end

class ClientMap < BaseMap
  def initialize(tiles , game)
    @game  = game
    @tiles = tiles.inject Hash.new do |hash , info|
      tile_class = Kernel.const_get "Client#{info[:type].capitalize}Tile"
      position   = Vector.new info[:x] , info[:y]
      
      hash[{x: position.x , y: position.y}] = tile_class.new(position)
      hash
    end
  end
end

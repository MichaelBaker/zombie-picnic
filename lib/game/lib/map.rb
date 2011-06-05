class MapTile
  attr_reader :type , :image , :position
  
  def initialize(position)
    @position = position
  end
end

class BaseMap
  attr_reader :tiles , :original_tiles
  
  def initialize(tiles , surface)
    @original_tiles = tiles
    
    @start_x = -1
    @start_y = 0
    
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
end

class ClientMap < BaseMap
  def initialize(tiles , suface)
    @tiles = tiles.inject Hash.new do |hash , info|
      tile_class = Kernel.const_get "Client#{info[:type].capitalize}Tile"
      position   = Vector.new info[:x] , info[:y]
      
      hash[{x: position.x , y: position.y}] = tile_class.new(position)
      hash
    end
  end
end

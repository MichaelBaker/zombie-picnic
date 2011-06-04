class BaseMapTile
  attr_accessor :x , :y , :type
  
  def initialize(x , y , type)
    @x     = x
    @y     = y
    @type  = type
  end
end

class BaseMap
  attr_reader :tiles , :original_tiles
  
  def initialize(tiles , surface)
    @original_tiles = tiles
    
    @start_x = -1
    @start_y = 0
    
    @tiles = tiles.inject Hash.new do |hash , info|
      hash[{x:info[:x] , y:info[:y]}] = BaseMapTile.new(info[:x] , info[:y] , info[:type])
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
      @tiles[{x: position[:x] + vector[0] , y: position[:y] + vector[1]}]
    end.uniq
  end
  
  def next_starting_position
    {x: @start_x += 1 , y: @start_y}
  end
end

class ClientMapTile < BaseMapTile
  attr_reader :image
  
  def initialize(x , y , type)
    super
    @image = Images[type]
  end
end

class ClientMap < BaseMap
  def initialize(tiles , suface)
    @tiles = tiles.inject Hash.new do |hash , info|
      hash[{x: info[:x] , y: info[:y]}] = ClientMapTile.new(info[:x] , info[:y] , info[:type])
      hash
    end
  end
end

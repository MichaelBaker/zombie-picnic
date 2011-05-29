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
    
    @tiles = tiles.map do |info|
      BaseMapTile.new info[:x] , info[:y] , info[:type]
    end
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

class ClientMap
  attr_reader :tiles
  
  def initialize(tiles , suface)
    @tiles = tiles.map do |info|
      ClientMapTile.new info[:x] , info[:y] , info[:type]
    end
  end
end

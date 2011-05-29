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
    
    @tiles = tiles.map do |info|
      BaseMapTile.new info[:x] , info[:y] , info[:type]
    end
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

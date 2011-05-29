class BaseMapTile
  def initialize(x , y , type)
    @x     = x
    @y     = y
    @type  = type
  end
end

class Map
  def initialize(tiles , surface)
    @tiles = tiles.map do |info|
      BaseMapTile.new info[:x] , info[:y] , info[:type]
    end
  end
end

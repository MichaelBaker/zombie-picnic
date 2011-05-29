class LoadMap
  attr_reader :tiles
  
  def initialize(map)
    @tiles = map.original_tiles
  end
end

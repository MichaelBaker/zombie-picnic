class LoadMap < Message
  attr_reader :tiles
  
  def initialize(map , options = {})
    super options
    @tiles = map.original_tiles
  end
end

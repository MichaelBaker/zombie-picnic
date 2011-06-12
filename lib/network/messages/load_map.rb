class LoadMap < Message
  attr_reader :map_hash
  
  def initialize(map , options = {})
    super options
    @map_hash = map.map_hash
  end
end

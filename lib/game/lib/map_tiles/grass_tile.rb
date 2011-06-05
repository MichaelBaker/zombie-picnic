class BaseGrassTile < MapTile
  def initialize(x , y)
    super
    @type           = :grass
    @speed_modifier = 1
  end
end

class ClientGrassTile < BaseGrassTile
  def initialize(x , y)
    super
    @image = Images[:grass]
  end
end

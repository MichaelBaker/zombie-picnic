class BaseGrassTile < MapTile
  def initialize(position)
    super
    @type           = :grass
    @speed_modifier = 1
  end
end

class ClientGrassTile < BaseGrassTile
  def initialize(position)
    super
    @image = Images[:grass]
  end
end

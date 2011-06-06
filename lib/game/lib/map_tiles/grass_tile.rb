class BaseGrassTile < MapTile
  def initialize(position)
    super
    @type           = :grass
    @speed_modifier = Settings.grass_movement_points
  end
end

class ClientGrassTile < BaseGrassTile
  def initialize(position)
    super
    @image = Images[:grass]
  end
end

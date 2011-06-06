class BaseWaterTile < MapTile
  def initialize(position)
    super
    @type           = :water
    @speed_modifier = Settings.water_movement_points
  end
end

class ClientWaterTile < BaseWaterTile
  def initialize(position)
    super
    @image = Images[:water]
  end
end

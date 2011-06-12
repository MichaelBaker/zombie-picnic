class BaseWoodTile < MapTile
  def initialize(position)
    super
    @type           = :wood
    @speed_modifier = Settings.wood_floor_movement_points
  end
end

class ClientWoodTile < BaseWoodTile
  def initialize(position)
    super
    @image = Images[:wood_floor]
  end
end

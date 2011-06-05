class BaseWaterTile < MapTile
  def initialize(position)
    super
    @type           = :water
    @speed_modifier = 1
  end
end

class ClientWaterTile < BaseGrassTile
  def initialize(position)
    super
    @image = Images[:water]
  end
end

class BaseWaterTile < MapTile
  def initialize(x , y)
    super
    @type           = :water
    @speed_modifier = 1
  end
end

class ClientWaterTile < BaseGrassTile
  def initialize(x , y)
    super
    @image = Images[:water]
  end
end

class BaseWaterTile < MapTile
  def initialize(position)
    super
    @type           = :water
    @speed_modifier = 4
  end
end

class ClientWaterTile < BaseWaterTile
  def initialize(position)
    super
    @image = Images[:water]
  end
end

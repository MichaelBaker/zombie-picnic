class WorldSnapshot
  attr_accessor :content , :tick
  
  def initialize(tick , snapshot)
    @tick    = tick
    @content = snapshot
  end
end
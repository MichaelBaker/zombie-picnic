class BaseRunner
  include Zombie
  
  syncable_attributes :position , :speed , :movement_points , :entity_id
  
  def initialize(position)
    @speed     = Settings.runner_speed
    @position  = position
    
    reset_movement_points
  end
  
  def reset_movement_points
    @movement_points = @speed
  end
end

class ClientRunner < BaseRunner
  attr_reader :image
  
  def initialize(attributes)
    super attributes[:position]
    
    self.attributes = attributes
    @image          = Images[:runner]
  end
  
  def self.from_attributes(attributes)
    new attributes
  end
end

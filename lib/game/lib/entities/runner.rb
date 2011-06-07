class BaseRunner
  attr_accessor :position , :speed , :movement_points
  attr_reader :entity_id
  
  def initialize(entity_id , position)
    @speed     = Settings.runner_speed
    @position  = position
    @entity_id = entity_id
    
    reset_movement_points
  end
  
  def reset_movement_points
    @movement_points = @speed
  end
  
  def attributes
    { entity_id:       @entity_id,
      position:        {x: position.x , y: position.y},
      speed:           @speed,
      movement_points: @movement_points }
  end
end

class ClientRunner < BaseRunner
  attr_reader :image
  
  def initialize(attributes)
    position = Vector.new attributes[:position][:x] , attributes[:position][:y]
    super attributes[:entity_id] , position
    
    @image           = Images[:runner]
    @speed           = attributes[:speed]
    @movement_points = attributes[:movement_points]
  end
  
  def self.from_attributes(attributes)
    new attributes
  end
end

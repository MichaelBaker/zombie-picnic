class BaseRunner
  include Zombie
  
  attr_accessor :position , :speed , :movement_points , :entity_id
  
  def initialize(position)
    @speed     = Settings.runner_speed
    @position  = position
    
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
    super position
    
    @entity_id       = attributes[:entity_id]
    @image           = Images[:runner]
    @speed           = attributes[:speed]
    @movement_points = attributes[:movement_points]
  end
  
  def self.from_attributes(attributes)
    new attributes
  end
end

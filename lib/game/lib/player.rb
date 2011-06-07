class BasePlayer
  attr_accessor :position , :name , :ready , :host , :speed , :movement_points
  attr_reader   :client_id , :entity_id
  
  def initialize(client_id , entity_id , position)
    @client_id  = client_id
    @entity_id  = entity_id
    @position   = position
    @ready      = false
    @name       = "Joining"
    @speed      = Settings.player_movement_points
    
    reset_movement_points
  end
  
  def movement_points_full?
    @movement_points == @speed
  end
  
  def reset_movement_points
    @movement_points = @speed
  end
  
  def host?
    host
  end
  
  def ready?
    @ready
  end
  
  def attributes
    { client_id: @client_id,
      entity_id: @entity_id,
      position:  {x: position.x , y: position.y},
      ready:     @ready,
      name:      @name,
      speed:     @speed }
  end
  
  def move_down(tile)
    self.position = self.position.down
    self.movement_points -= tile.speed_modifier
  end
  
  def move_up(tile)
    self.position = self.position.up
    self.movement_points -= tile.speed_modifier
  end
  
  def move_left(tile)
    self.position = self.position.left
    self.movement_points -= tile.speed_modifier
  end
  
  def move_right(tile)
    self.position = self.position.right
    self.movement_points -= tile.speed_modifier
  end
end

class ClientPlayer < BasePlayer
  attr_reader :image
  
  def initialize(attributes)
    position = Vector.new attributes[:position][:x] , attributes[:position][:y]
    
    super(attributes[:client_id] , attributes[:entity_id] , position)
    
    @ready = attributes[:ready]
    @image = Images[:player]
    @name  = attributes[:name]
    @speed = attributes[:speed]
  end
  
  def self.from_attributes(attributes)
    new(attributes)
  end
end

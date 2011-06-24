class BasePlayer
  include Entity
  
  syncable_attributes :position , :name , :ready , :host , :speed , :movement_points , :entity_id , :client_id , :sight_range
  
  def initialize(client_id , position)
    @client_id   = client_id
    @position    = position
    @ready       = false
    @name        = "Joining"
    @speed       = Settings.player_movement_points
    @sight_range = 5
    
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
    super attributes[:client_id] , attributes[:position]
    self.attributes = attributes
    @image          = Images[:player]
  end
  
  def self.from_attributes(attributes)
    new attributes
  end
end

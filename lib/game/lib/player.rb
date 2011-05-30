class BasePlayer
  attr_accessor :position , :name , :ready
  attr_reader   :client_id , :entity_id
  
  def initialize(client_id , entity_id , position)
    @client_id = client_id
    @entity_id = entity_id
    @position  = position
    @ready     = false
    @name      = "Mr. Boner von Periwinkle"
  end
  
  def ready?
    @ready
  end
  
  def attributes
    {client_id: @client_id , entity_id: @entity_id , position: position , ready: @ready , name: @name}
  end
end

class ClientPlayer < BasePlayer
  attr_reader :image
  
  def initialize(attributes)
    super(attributes[:client_id] , attributes[:entity_id] , attributes[:position])
    @ready = attributes[:ready]
    @image = Images[:player]
    @name  = attributes[:name]
  end
  
  def self.from_attributes(attributes)
    new(attributes)
  end
end

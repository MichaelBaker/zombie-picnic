class BasePlayer
  attr_reader :client_id , :entity_id , :position
  
  def initialize(client_id , entity_id , position)
    @client_id = client_id
    @entity_id = entity_id
    @position  = position
  end
  
  def attributes
    {client_id: @client_id , entity_id: @entity_id , position: position}
  end
end

class ClientPlayer < BasePlayer
  attr_reader :image
  
  def initialize(client_id , entity_id , position)
    super
    @image = Images[:player]
  end
  
  def self.from_attributes(attributes)
    new(attributes[:client_id] , attributes[:entity_id] , attributes[:position])
  end
end

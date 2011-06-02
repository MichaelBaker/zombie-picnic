require "forwardable"

class Entities
  extend Forwardable
  
  def_delegators :entities , :each , :map , :reduce , :filter , :inject , :any? , :empty? , :size
  
  def initialize
    @entities   = Hash.new
    @players    = Hash.new
    @next_id    = 0
  end
  
  def entities
    @entities.values
  end
  
  def next_id
    @next_id += 1
  end
  
  def <<(entity)
    if !entity.respond_to?(:entity_id) || entity.entity_id.nil?
      raise ArgumentError.new("Entities must have an entity_id")
    end
    
    if entity.respond_to?(:client_id)
      add_player entity
    else
      @entities[entity.entity_id] = entity
    end
  end
  
  def add_player(entity)
    @entities[entity.entity_id] = entity
    @players[entity.client_id]  = entity
  end
  
  def add_entity_from_server(message)
    entity_class = Object.const_get "Client#{message.type}"
    self << entity_class.from_attributes(message.attributes)
  end
  
  def find_player_by_client_id(id)
    @players[id]
  end
  
  def players
    @players.values
  end
end

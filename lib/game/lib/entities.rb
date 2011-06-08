require "forwardable"

class Entities
  extend Forwardable
  
  def_delegators :entities , :each , :map , :reduce , :filter , :inject , :any? , :empty? , :size
  
  def initialize
    @entities   = Hash.new
    @players    = Hash.new
    @zombies    = Hash.new
    @next_id    = 0
  end
  
  def entity_at?(position)
    entities.each do |entity|
      return entity if entity.position == position
    end
    
    nil
  end
  
  def entities
    @entities.values
  end
  
  def [](entity_id)
    @entities[entity_id]
  end
  
  def next_id
    @next_id += 1
  end
  
  def <<(entity)
    if !entity.respond_to?(:entity_id)
      raise ArgumentError.new("Entities must have an entity_id")
    end
    
    entity.entity_id = next_id
    
    if entity.kind_of? BasePlayer
      add_player entity
    elsif entity.kind_of? Zombie
      add_zombie entity
    else
      @entities[entity.entity_id] = entity
    end
  end
  
  def add_zombie(entity)
    
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
  
  def zombies
    @zombies.values
  end

private

  def add_zombie(entity)
    @entities[entity.entity_id] = entity
    @zombies[entity.entity_id]  = entity
  end
  
  def add_player(entity)
    @entities[entity.entity_id] = entity
    @players[entity.client_id]  = entity
  end
end

require "forwardable"

class Entities
  extend Forwardable
  
  def_delegators :entities , :each , :map , :reduce , :filter , :inject , :any? , :empty?
  
  def initialize
    @hash    = Hash.new
    @next_id = 0
  end
  
  def entities
    @hash.values
  end
  
  def next_id
    @next_id += 1
  end
  
  def <<(entity)
    @hash[entity.entity_id] = entity
  end
  
  def add_entity_from_server(message)
    entity_class = Object.const_get "Client#{message.type}"
    self << entity_class.from_attributes(message.attributes)
  end
end

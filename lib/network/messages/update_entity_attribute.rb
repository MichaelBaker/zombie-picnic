class UpdateEntityAttribute < Message
  attr_reader :entity_id , :attribute , :value
  
  def initialize(entity , attribute)
    @entity_id = entity.entity_id
    @attribute = attribute
    @value     = entity.send attribute
  end
end
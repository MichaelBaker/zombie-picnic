class CreateEntity < Message
  attr_reader :attributes , :type
  
  def initialize(entity , options = {})
    super options
    @type       = entity.class.name.gsub /Base/ , ""
    @attributes = entity.syncable_attributes
  end
end

class SetName < Message
  attr_reader :name
  
  def initialize(name , options = {})
    super options
    @name = name
  end
end
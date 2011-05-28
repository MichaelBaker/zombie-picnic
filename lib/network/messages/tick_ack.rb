def TickAck < ClientMessage
  attr_accessor :tick
  
  def initialize(client_id , tick)
    super client_id
    @tick = tick
  end
end
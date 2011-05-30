class Message
  attr_accessor :client_id
end

class CommandMessage < Message
  attr_accessor :id , :content , :udp_port
end

class ClientId < CommandMessage
  def initialize(id)
    @id = id
  end
end

class UDPPort < CommandMessage
  attr_accessor :port
  
  def initialize(id)
    @id   = id
  end
end

class Message
  attr_accessor :id , :content , :udp_port
  
  def initialize(content)
    @content = content
  end
end

class CommandMessage < Message
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

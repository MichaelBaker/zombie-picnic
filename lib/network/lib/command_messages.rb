class Message
  attr_accessor :client_id
  
  def initialize(options = {})
    @client_id = options[:client_id]
  end
end

class CommandMessage < Message
  attr_accessor :id , :content , :udp_port
end

class ClientId < CommandMessage
  def initialize(id)
    @id = id
  end
end
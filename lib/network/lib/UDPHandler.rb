require "socket"

module UDPHandler
  include Callback
  
  def receive_data(data)
    message          = Marshal::load(data)
    message.udp_port = Socket.unpack_sockaddr_in(get_peername)[0]
    emit :message , message
  end
  
  def send_object(object , ip , port)
    self.send_datagram Marshal::dump(object) , ip , port
  end
end

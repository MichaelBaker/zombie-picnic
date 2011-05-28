require "socket"

class Connection
  attr_accessor :id , :udp_port , :udp_socket
  
  def initialize(id , tcp_connection , udp_socket)
    @id             = id
    @ip             = Socket.unpack_sockaddr_in(tcp_connection.get_peername)[1]
    @tcp_connection = tcp_connection
    @udp_socket     = udp_socket
  end
  
  def send_tcp_object(object)
    @tcp_connection.send_object object
  end
  
  def send_udp_object(object)
    return unless @udp_port
    @udp_socket.send_object object , @ip , @udp_port
  end
end

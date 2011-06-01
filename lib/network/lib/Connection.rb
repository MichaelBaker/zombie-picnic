require "socket"

class Connection
  attr_accessor :id
  
  def initialize(id , tcp_connection)
    @id             = id
    @ip             = Socket.unpack_sockaddr_in(tcp_connection.get_peername)[1]
    @tcp_connection = tcp_connection
  end
  
  def send_tcp_object(object)
    @tcp_connection.send_object object
  end
end

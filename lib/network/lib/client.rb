require "socket"

class GameClient
  include Callback
  
  def initialize(ip , tcp_port , udp_port)
    @server_ip         = ip
    @server_tcp_port   = tcp_port
    @server_udp_port   = udp_port
    @periodic_timers   = Hash.new
  end
  
  def deliver_message(message)
    emit :message , message
  end
  
  def handle_command_message(message)
    case message
    when ClientId
      @id = message.id
      @udp_socket.send_object UDPPort.new(@id) , @server_ip , @server_udp_port
      emit :connect
    end
  end
  
  def start_udp_socket
    @udp_socket = EventMachine::open_datagram_socket "localhost" , 0 , UDPHandler do |connection|
      connection.on :message do |message| self.deliver_message message end
    end
  end
  
  def start_tcp_socket
    @tcp_socket = EventMachine::connect @server_ip , @server_tcp_port , TCPHandler do |connection|
      connection.on :message         do |message| self.deliver_message message        end
      connection.on :command_message do |message| self.handle_command_message message end
    end
  end
  
  def send_tcp_message(object)
    object.id = @id
    @tcp_socket.send_object object
  end
  
  def send_udp_message(object)
    object.id = @id
    @udp_socket.send_object object , @server_ip , @server_udp_port
  end
  
  def start
    Thread.new do
      EventMachine::run do
        self.start_udp_socket
        self.start_tcp_socket
      end
    end
  end
end

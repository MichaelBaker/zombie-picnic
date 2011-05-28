require "socket"

require_relative "Connection"

class GameServer
  include Callback
  
  def initialize(tcp_port , udp_port)
    @next_id           = 0
    @tcp_port          = tcp_port
    @udp_port          = udp_port
    @connections       = Hash.new
  end
  
  def ready
    emit :ready
  end
  
  def tcp_ready
    @tcp_ready = true
    ready if @udp_ready
  end
  
  def udp_ready
    @udp_ready = true
    ready if @tcp_ready
  end
  
  def create_new_connection(connection)
    connection = Connection.new(next_id , connection , @udp_socket)
    @connections[connection.id] = connection
  end
  
  def next_id
    @next_id += 1
  end
  
  def deliver_message(message)
    emit :message , message
  end
  
  def handle_command_message(message)
  end
  
  def start_tcp_server
    EventMachine::start_server "localhost" , @tcp_port , TCPHandler do |connection|
      connection.on :message         do |message| self.deliver_message message        end  
      connection.on :command_message do |message| self.handle_command_message message end
      
      connection = self.create_new_connection(connection)
      connection.send_tcp_object ClientId.new(connection.id)
      emit :connect , connection.id
    end
    
    tcp_ready
  end
  
  def start_udp_server
    @udp_socket = EventMachine::open_datagram_socket "localhost" , @udp_port , UDPHandler do |connection|
      connection.on :message do |message|
        if message.udp_port && (client = find_client_by_id(message.id))
          client.udp_port = message.udp_port
        end
        
        self.deliver_message message
      end
    end
    
    udp_ready
  end
  
  def find_client_by_id(id)
    @connections[id]
  end
  
  def broadcast_tcp_message(object)
    @connections.values.each {|connection| connection.send_tcp_object object}
  end
  
  def broadcast_udp_message(object)
    @connections.values.each {|connection| connection.send_udp_object object}
  end
  
  def stop
    @thread.exit
  end
  
  def start
    @thread = Thread.new do
      EventMachine::run do
        self.start_tcp_server
        self.start_udp_server
      end
    end
  end
end

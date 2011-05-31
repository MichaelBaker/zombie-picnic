require "socket"

require_relative "connection"

class GameServer
  include Callback
  
  def initialize(tcp_port)
    @next_id           = 0
    @tcp_port          = tcp_port
    @connections       = Hash.new
  end
  
  def create_new_connection(connection)
    connection = Connection.new(next_id , connection)
    @connections[connection.id] = connection
  end
  
  def next_id
    @next_id += 1
  end
  
  def deliver_message(client_id , message)
    emit :message , client_id , message
  end
  
  def handle_command_message(message)
  end
  
  def start_tcp_server
    EventMachine::start_server "0.0.0.0" , 8337 , TCPHandler do |connection|
      connection.on :message         do |message| self.deliver_message connection.id , message end  
      connection.on :command_message do |message| self.handle_command_message message          end
      
      connection = self.create_new_connection(connection)
      connection.send_tcp_object ClientId.new(connection.id)
      emit :connect , connection.id
    end
  end
  
  def find_client_by_id(id)
    @connections[id]
  end
  
  def broadcast_tcp_message(object)
    @connections.values.each {|connection| connection.send_tcp_object object}
  end
  
  def send_tcp_message_to(client_id , object)
    @connections[client_id].send_tcp_object object
  end
  
  def stop
    @thread.exit
  end
  
  def start
    @thread = Thread.new do
      EventMachine::run do
        self.start_tcp_server
      end
    end
  end
end

require "socket"

class GameClient
  include Callback
  
  def initialize(ip , tcp_port)
    @server_ip         = ip
    @server_tcp_port   = tcp_port
    @periodic_timers   = Hash.new
  end
  
  def deliver_message(message)
    emit :message , message
  end
  
  def handle_command_message(message)
    case message
    when ClientId
      @id = message.id
      emit :connect
    end
  end
  
  def start_tcp_socket
    @tcp_socket = EventMachine::connect @server_ip , @server_tcp_port , TCPHandler do |connection|
      connection.on :message         do |message| self.deliver_message message        end
      connection.on :command_message do |message| self.handle_command_message message end
    end
  end
  
  def send_tcp_message(object)
    @tcp_socket.send_object object
  end
  
  def start
    Thread.new do
      EventMachine::run do
        begin
        self.start_tcp_socket
      rescue Exception => e
        puts e
        puts e.backtrace
      end
      end
    end
  end
end

require "yaml"
require_relative "server_entity_management"
require_relative "server_state_management"

class ServerWindow < Window
  include EntityManagement
  include StateManagement
  
  attr_reader :entities , :network , :host , :map
  
  def initialize(network)
    super 200 , 100 , false
    
    @entities = Entities.new
    @state    = ServerWaitingToStartState.new(self)
    @network  = network
    @messages = MessageQueue.new
    
    @network.on :message do |client_id , message|
      message.client_id = client_id
      @messages << message
    end
      
    @network.on :connect do |client_id|
      return unless @state.instance_of?(ServerWaitingToStartState)
      
      @network.send_tcp_message_to client_id , YourId.new(client_id: client_id)
      @network.send_tcp_message_to client_id , LoadMap.new(@map)
      send_entities_to             client_id
      create_player                client_id
      begin
      broadcast_new_entity         @entities.players.last
    rescue Exception => e
      puts e
    end
      
      if @host
        notify_host_that_client_isnt_ready client_id
      else
        make_host @entities.players.last
      end
    end
  end

  def notify_host_that_client_isnt_ready(client_id)
    @network.send_tcp_message_to @host.client_id , NotReadyToStart.new(client_id: client_id)
  end
  
  def draw
  end
  
  def update
    @messages.each {|message| @state.handle_message message}
  end
  
  def button_down(id)
    close if id == KbEscape
    @state.button_down id
  end

  def load_map(map_name)
    map_path = File.dirname(__FILE__) + "/../../../assets/maps/" + map_name + ".map"
    @map = BaseMap.new YAML::load_file(map_path)[:tiles] , self
  end
    
  def start
    @network.start
    show
  end
  
  def start_game
    initialize_turn_order
    
    change_state ServerPlayerTurnState , self , current_player
    
    @network.send_tcp_message_to            current_turn_client_id , YourTurn.new(client_id: current_turn_client_id)
    @network.send_tcp_message_to_all_except current_turn_client_id , StartPlayerTurn.new(client_id: current_turn_client_id)
  end
end

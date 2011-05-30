require "yaml"

class ServerWindow < Window
  attr_reader :entities , :network , :host
  
  def initialize(network)
    super 200 , 100 , false
    
    @entities = Entities.new
    @state    = ServerWaitingToStartState.new(self)
    @network  = network
    
    @network.on :message do |client_id , message|
      @state.handle_message client_id , message
    end
      
    @network.on :connect do |client_id|
      @network.send_tcp_message_to client_id , LoadMap.new(@map)
      @entities.each {|entity| @network.send_tcp_message_to client_id , CreateEntity.new(entity)}
      
      new_player = BasePlayer.new(client_id , @entities.next_id , @map.next_starting_position)
      @entities << new_player
      
      @network.broadcast_tcp_message CreateEntity.new(new_player)
      @network.send_tcp_message_to client_id , RequestName.new
      
      if @host
        @network.send_tcp_message_to @host.client_id , NotReadyToStart.new(client_id)
      else
        @host = new_player
        @host.ready = true
        message = ReadyToStart.new
        message.client_id = client_id
        @network.send_tcp_message_to client_id , RequestStart.new
        @network.send_tcp_message_to client_id , message
      end
    end
  end
  
  def draw
  end
  
  def update
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
end

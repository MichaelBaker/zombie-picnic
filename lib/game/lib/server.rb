require "yaml"

class ServerWindow < Window
  attr_reader :entities , :network
  
  def initialize(network)
    super 200 , 100 , false
    
    @entities = Entities.new
    @state    = ServerWaitingToStartState.new(self)
    @network  = network
    
    @network.on :message do |message|
      self.state.handle_message message
    end
      
    @network.on :connect do |client_id|
      @network.send_tcp_message_to client_id , LoadMap.new(@map)
      
      @entities.each do |entity|
        @network.send_tcp_message_to client_id , CreateEntity.new(entity)
      end
      
      new_player = BasePlayer.new(client_id , @entities.next_id , @map.next_starting_position)
      @host      = new_player if @entities.empty?
      @entities << new_player
      
      @network.broadcast_tcp_message CreateEntity.new(new_player)
      @network.send_tcp_message_to(client_id , RequestStart.new) if @host.client_id == client_id
    end
  end
  
  def draw
  end
  
  def update
  end
  
  def button_down(id)
    close if id == Gosu::KbEscape
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

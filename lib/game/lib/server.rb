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
      send_entities_to             client_id
      create_player                client_id
      broadcast_new_entity         @entities.players.last
      
      if @host
        notify_host_that_client_isnt_ready client_id
      else
        make_host @entities.players.last
      end
    end
  end
  
  def make_host(player)
    @host = player
    @host.ready = true
    @network.send_tcp_message_to player.client_id , RequestStart.new(client_id: player.client_id)
    @network.send_tcp_message_to player.client_id , ReadyToStart.new(client_id: player.client_id)
  end

  def notify_host_that_client_isnt_ready(client_id)
    @network.send_tcp_message_to @host.client_id , NotReadyToStart.new(client_id: client_id)
  end
  
  def broadcast_new_entity(entity)
    @network.broadcast_tcp_message CreateEntity.new(entity)
  end
  
  def send_entities_to(client_id)
    @entities.each do |entity|
      @network.send_tcp_message_to client_id , CreateEntity.new(entity)
    end
  end
  
  def create_player(client_id)
    @entities << BasePlayer.new(client_id , @entities.next_id , @map.next_starting_position)
    @network.send_tcp_message_to client_id , RequestName.new
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

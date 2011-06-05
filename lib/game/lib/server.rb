require "yaml"

class ServerWindow < Window
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
      broadcast_new_entity         @entities.players.last
      
      if @host
        notify_host_that_client_isnt_ready client_id
      else
        make_host @entities.players.last
      end
    end
  end
  
  def change_state(state_class , *args)
    @state = state_class.new(*args)
  end
  
  def make_host(player)
    player.host = true
    @host       = player
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
  
  def current_turn_client_id
    @turn_order[@turn]
  end
  
  def initialize_turn_order
    @turn_order = @entities.players.map(&:client_id).shuffle
    @turn       = 0
  end
  
  def current_player
    @entities.find_player_by_client_id current_turn_client_id
  end
  
  def advance_turn
    @turn = (@turn + 1) % @turn_order.size
    
    change_state ServerPlayerTurnState , self , current_player
    
    @network.send_tcp_message_to            current_turn_client_id , YourTurn.new(client_id: current_turn_client_id)
    @network.send_tcp_message_to_all_except current_turn_client_id , StartPlayerTurn.new(client_id: current_turn_client_id)
  end
end

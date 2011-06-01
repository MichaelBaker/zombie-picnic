class ServerWaitingToStartState
  def initialize(game)
    @game = game
  end
  
  def handle_message(client_id , message)
    case message
    when SetName
      message.client_id = client_id
      @game.entities.find_player_by_client_id(client_id).name = message.name
      @game.network.broadcast_tcp_message message
    when ReadyToStart
      message.client_id = client_id
      @game.entities.find_player_by_client_id(client_id).ready = true
      @game.network.send_tcp_message_to @game.host.client_id , message
    end
  end
  
  def button_down(id)
  end
end

class ClientWaitingToStartState
  def initialize(game)
    @game   = game
    @events = Array.new
  end
  
  def handle_message(message)
    case message
    when LoadMap
      @game.map = ClientMap.new(message.tiles , @game)
    when CreateEntity
      @game.entities.add_entity_from_server message
    when RequestStart
      @game.ui["status text"].text = "Let's wait for the rabble to ready up"
    when RequestName
      @game.network.send_tcp_message SetName.new(@game.name)
    when SetName
      @game.entities.find_player_by_client_id(message.client_id).name = message.name
    when ReadyToStart
      @game.entities.find_player_by_client_id(message.client_id).ready = true
      @game.ui["status text"].text = self.ready_message
    when NotReadyToStart
      @game.entities.find_player_by_client_id(message.client_id).ready = false
      @game.ui["status text"].text = self.ready_message
    else
      puts message
    end
  end
  
  def ready_message
    if @game.entities.players.all? {|player| player.ready?}
      "Everyone is ready! Hit ENTER to get thangs goin'"
    else
      players_status = @game.entities.players.map do |player|
        "#{player.name}:#{player.ready? ? "Ready" : "Not Ready"}"
      end
      
      "Let's wait for the rabble to ready up\n\n" + players_status.join("\n")
    end
  end
  
  def button_down(id)
    case id
    when KbEnter , KbReturn
      @game.network.send_tcp_message ReadyToStart.new
    end
  end
end

class ServerWaitingToStartState
  def initialize(game)
    @game = game
  end
  
  def handle_message(message)
    player = @game.entities.find_player_by_client_id(message.client_id)
    
    case message
    when SetName
      player.name = message.name
      @game.network.broadcast_tcp_message message
    when ReadyToStart
      player.ready = true
      @game.network.broadcast_tcp_message message
    when NotReadyToStart
      player.ready = false
      @game.network.broadcast_tcp_message message
    end
  end
  
  def button_down(id)
  end
end

class ClientWaitingToStartState
  def initialize(game)
    @game   = game
    
    @game.add_widget TextWidget.new("Hey there! Hit ENTER when you're ready to start" , id: "status text")
    
    @ready  = false
    @events = Array.new
  end
  
  def handle_message(message)
    case message
    when LoadMap
      @game.ui["status text"].text = "Loading Map"
      @game.map = ClientMap.new(message.tiles , @game)
      @game.ui["status text"].text = "Map is ready" if @game.ui["status text"].text == "Loading Map"
    when CreateEntity
      @game.entities.add_entity_from_server message
    when RequestStart
      @game.host!
      @game.ui["status text"].text = "Let's wait for the rabble to ready up"
    when RequestName
      @game.network.send_tcp_message SetName.new(@game.name)
    when SetName
      @game.entities.find_player_by_client_id(message.client_id).name = message.name
      @game.ui["status text"].text = self.ready_message
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
    if @game.entities.players.all? &:ready?
      @game.host? ? "Everyone is ready! Hit ENTER to get thangs goin'\n\n" + player_status_text :
                    "Everyone is ready! Waiting for host to start\n\n" + player_status_text
    else
      "Let's wait for the rabble to ready up\n\n" + player_status_text
    end
  end
  
  def player_status_text
    players_status = @game.entities.players.map do |player|
      "#{player.name}:#{player.ready? ? "Ready" : "Not Ready"}"
    end
    
    players_status.join("\n")
  end
  
  def button_down(id)
    case id
    when KbEnter , KbReturn
      if @ready
        @ready = false
        @game.network.send_tcp_message NotReadyToStart.new
      else
        @ready = true
        @game.network.send_tcp_message ReadyToStart.new
      end
    end
  end
end

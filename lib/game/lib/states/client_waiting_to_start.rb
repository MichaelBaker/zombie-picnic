class ClientWaitingToStartState
  include State
  
  def initialize(game)
    @game  = game
    @ready = false
    @game.add_widget TextWidget.new("" , id: "status text" , background: [0.5 , 0.5 , 0.5 , 0.7])
  end
  
  handle LoadMap do
    @game.ui["status text"].text = "Loading Map"
    @game.map = ClientMap.new(message.map_hash , @game)
    @game.ui["status text"].text = "Map is ready" if @game.ui["status text"].text == "Loading Map"
  end
  
  handle CreateEntity do
    @game.entities.add_entity_from_server message
  end
  
  handle RequestStart do
    @game.host!
    @game.ui["status text"].text = "Let's wait for the rabble to ready up"
  end
  
  handle RequestName do
    @game.network.send_tcp_message SetName.new(@game.name)
  end
  
  handle SetName do
    @game.entities.find_player_by_client_id(message.client_id).name = message.name
    @game.ui["status text"].text = self.ready_message
  end
  
  handle ReadyToStart do
    @game.entities.find_player_by_client_id(message.client_id).ready = true
    @game.ui["status text"].text = self.ready_message
  end
  
  handle NotReadyToStart do
    @game.entities.find_player_by_client_id(message.client_id).ready = false
    @game.ui["status text"].text = self.ready_message
  end
  
  handle YourId do
    @game.my_client_id = message.client_id
  end
  
  default do
    puts message
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
    when KbUp
      @game.move_viewport :up
    when KbDown
      @game.move_viewport :down
    when KbRight
      @game.move_viewport :right
    when KbLeft
      @game.move_viewport :left
    end
  end
end

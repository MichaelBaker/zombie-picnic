class ServerWaitingToStartState
  def initialize(game)
    @game = game
  end
  
  def handle_message(message)
    puts message
  end
end

class ClientWaitingToStartState
  def initialize(game)
    @game = game
  end
  
  def handle_message(message)
    puts "Test - #{message}"
    case message
    when LoadMap
      @game.map = ClientMap.new(message.tiles , @game)
    when CreateEntity
      @game.entities.add_entity_from_server message
    when RequestStart
      @game.message         = "Press ENTER to start"
      @game.message_changed = true
    else
      puts message
    end
  end
end
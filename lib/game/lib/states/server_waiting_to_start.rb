class ServerWaitingToStartState
  include State
  
  def initialize(game)
    @game = game
  end
  
  before do
    @player = @game.entities.find_player_by_client_id(message.client_id)
  end
  
  handle SetName do
    @player.name = message.name
    @game.network.broadcast_tcp_message message
  end
  
  handle ReadyToStart do
    if @player.host?
      @game.start_game if @game.entities.players.all? &:ready?
    else
      @player.ready = true
      @game.network.broadcast_tcp_message message
    end
  end
  
  handle NotReadyToStart do
    if @player.host?
      @game.start_game if @game.entities.players.all &:ready?
    else
      @player.ready = false
      @game.network.broadcast_tcp_message message
    end
  end
end
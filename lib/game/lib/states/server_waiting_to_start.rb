class ServerWaitingToStartState
  include State
  
  def initialize(game)
    @game = game
  end
  
  before do |message|
    @player = @game.entities.find_player_by_client_id(message.client_id)
  end
  
  handle SetName do |message|
    @player.name = message.name
    @game.network.broadcast_tcp_message message
  end
  
  handle ReadyToStart do |message|
    if @player.host?
      @game.start_game if @game.entities.players.all? &:ready?
    else
      @player.ready = true
      @game.network.broadcast_tcp_message message
    end
  end
  
  handle NotReadyToStart do |message|
    if @player.host?
      @game.start_game if @game.entities.players.all &:ready?
    else
      @player.ready = false
      @game.network.broadcast_tcp_message message
    end
  end
  
  def button_down(id)
  end
end
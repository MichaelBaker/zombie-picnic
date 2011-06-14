class YourTurnState
  include State
  
  attr_reader :player
  
  def initialize(game , player)
    @game = game
    
    @game.add_widget TextWidget.new("It's your turn!" , id: "status text")
    
    @player = player
    @player.reset_movement_points
  end
  
  def button_down(id)
    case id
    when KbEnter , KbReturn
      @game.network.send_tcp_message EndTurn.new
    when KbA
      @game.network.send_tcp_message MovePlayerLeft.new
    when KbD
      @game.network.send_tcp_message MovePlayerRight.new
    when KbW
      @game.network.send_tcp_message MovePlayerUp.new
    when KbS
      @game.network.send_tcp_message MovePlayerDown.new
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
class ClientPlayerTurnState
  include State
  
  attr_reader :player
  
  def initialize(game , player)
    @game   = game
    
    @player = player
    @player.reset_movement_points
    
    @game.add_widget TextWidget.new("It's #{player.name}'s turn!" , id: "status text")
  end
  
  def button_down(id)
    case id
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

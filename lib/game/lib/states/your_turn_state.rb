class YourTurnState
  include State
  
  def initialize(game , player)
    @game = game
    
    @game.add_widget TextWidget.new("It's your turn!" , id: "status text")
    
    @player = player
  end
  
  def button_down(id)
    
  end
end
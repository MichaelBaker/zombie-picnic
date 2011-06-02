class YourTurnState
  include State
  
  def initialize(game)
    @game = game
    
    @game.add_widget TextWidget.new("It's your turn!" , id: "status text")
  end
  
  def button_down(id)
    
  end
end
class YourTurnState
  def initialize(game)
    @game = game
    
    @game.add_widget TextWidget.new("It's your turn!" , id: "status text")
  end
  
  def handle_message(message)
    
  end
  
  def button_down(id)
    
  end
end
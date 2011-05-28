class ClientWindow < Window
  def initialize(network)
    super 1280 , 800 , false
    
    @network = network
    @network.on :message do |message| self.handle_message message end
  end
  
  def handle_message(message)
    puts message
  end
  
  def draw
  end
  
  def update
  end
  
  def button_down(id)
    close if id == Gosu::KbEscape
  end
  
  def start
    @network.start
    show
  end
end
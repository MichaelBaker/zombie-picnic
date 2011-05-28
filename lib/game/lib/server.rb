class ServerWindow < Window
  def initialize(network)
    super 200 , 100 , false
    
    @network = network
    @network.on :connect do |client_id| puts "A new client connected" end
    @network.on :message do |message|   self.handle_message message   end
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
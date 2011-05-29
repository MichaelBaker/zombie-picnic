class ClientWindow < Window
  def initialize(network)
    super 1280 , 800 , false
    
    @network = network
    @network.on :message do |message| self.handle_message message end
  end
  
  def handle_message(message)
    case message
    when LoadMap then @map = ClientMap.new(message.tiles , self)
    end
  end
  
  def draw
    if @map
      @map.tiles.each do |tile|
        tile.image.draw tile.x * tile.image.width , tile.y * tile.image.height , 1
      end
    end
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
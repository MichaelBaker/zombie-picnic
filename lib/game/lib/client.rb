TranslucentBlack = Color.rgba(0 , 0 , 0 , 100)

class ClientWindow < Window
  include ShallotUI
  
  attr_accessor :entities , :network , :map , :message , :message_changed , :state , :name
  
  def initialize(network , name)
    super 1280 , 800 , false

    @name     = name
    @entities = Entities.new
    @state    = ClientWaitingToStartState.new(self)
    
    add_widget TextWidget.new("Hey there! Hit ENTER when you're ready to start")
    
    @network = network
    @network.on :message do |message| self.state.handle_message message end
  end
  
  def message=(message)
    @message         = message
    @message_changed = true
  end
  
  def draw
    if @map
      @map.tiles.each do |tile|
        tile.image.draw tile.x * tile.image.width , tile.y * tile.image.height , 1
      end
      
      @entities.each do |entity|
        entity.image.draw entity.position[:x] * entity.image.width , entity.position[:y] * entity.image.height , 1
      end
    end
    
    draw_ui
  end
  
  def update
  end
  
  def button_down(id)
    close if id == KbEscape
    @state.button_down id
  end
  
  def start
    @network.start
    show
  end
end

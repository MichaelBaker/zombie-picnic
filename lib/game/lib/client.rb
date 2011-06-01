require "thread"

TranslucentBlack = Color.rgba(0 , 0 , 0 , 100)

class ClientWindow < Window
  include ShallotUI
  
  attr_accessor :entities , :network , :map , :message , :message_changed , :state , :name
  
  def initialize(network , name)
    super 1280 , 800 , false

    @name      = name
    @semaphore = Mutex.new
    @messages  = Array.new
    @entities  = Entities.new
    @state     = ClientWaitingToStartState.new(self)
    
    add_widget TextWidget.new("Hey there! Hit ENTER when you're ready to start" , id: "status text")
    
    @network = network
    @network.on :message do |message| self.queue_message message end
  end
  
  def queue_message(message)
    @semaphore.synchronize {
      @messages << message
    }
  end
  
  def handle_messages
    @semaphore.synchronize {
      @messages.each {|message| self.state.handle_message message}
      @messages.clear
    }
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
    handle_messages
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

TranslucentBlack = Color.rgba(0 , 0 , 0 , 100)

class ClientWindow < Window
  include Renderer
  include ShallotUI
  
  attr_accessor :entities , :network , :map , :state , :name
  
  def initialize(network , name , fullscreen = false)
    super 1280 , 800 , fullscreen

    @name      = name
    @messages  = MessageQueue.new
    @entities  = Entities.new
    @state     = ClientWaitingToStartState.new(self)
    
    @network = network
    @network.on :message do |message| @messages << message end
  end
  
  def change_state(state_class , *args)
    clear_ui
    @state = state_class.new(*args)
  end
  
  def host?
    @host
  end
  
  def host!
    @host = true
  end
  
  def update
    @messages.each {|message| @state.handle_message message}
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

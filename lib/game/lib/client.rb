TranslucentBlack = Color.rgba(0 , 0 , 0 , 100)

class ClientWindow < Window
  include Renderer
  include ShallotUI
  
  attr_accessor :entities , :network , :map , :state , :name , :my_client_id
  
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
  
  def current_player_client_id
    @state.player.client_id if @state.respond_to?(:player)
  end
  
  def host?
    @host
  end
  
  def host!
    @host = true
  end
  
  def update
    @messages.each do |message|
      case message
      when UpdateEntityAttribute
        entity = @entities[message.entity_id]
        entity.send "#{message.attribute}=" , message.value if entity
      else
        @state.handle_message message
      end
    end
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

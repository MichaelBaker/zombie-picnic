require "yaml"

class ServerWindow < Window
  def initialize(network)
    super 200 , 100 , false
    
    @network = network
    
    @network.on :connect do |client_id|
      @network.send_tcp_message_to client_id , LoadMap.new(@map)
    end
    
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

  def load_map(map_name)
    map_path = File.dirname(__FILE__) + "/../../../assets/maps/" + map_name + ".map"
    @map = BaseMap.new YAML::load_file(map_path)[:tiles] , self
  end
    
  def start
    @network.start
    show
  end
end
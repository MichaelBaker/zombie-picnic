class NetworkInterface
  include Callback
  
  def initialize(machine)
    @machine = machine
  end
  
  def deliver_message(message)
    emit :message , message
  end
  
  def ready
    emit :ready
  end
  
  def start
    @machine.on :message do |message|
      self.deliver_message message
    end
    
    @machine.on :ready do
      self.ready
    end
    
    @machine.start
  end
end

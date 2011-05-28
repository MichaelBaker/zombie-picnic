module TCPHandler
  include Callback
  include EventMachine::Protocols::ObjectProtocol
  
  def handle_command_message(message)
    emit :command_message , message
  end
  
  def handle_message(message)
    emit :message , message
  end
  
  def receive_object(object)
    if object.kind_of? CommandMessage
      handle_command_message object
    else
      handle_message object
    end
  end
end

class NotReadyToStart < Message
  attr_reader :client_id
  
  def initialize(client_id)
    @client_id = client_id
  end
end
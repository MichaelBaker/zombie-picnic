module EntityManagement
  def broadcast_new_entity(entity)
    @network.broadcast_tcp_message CreateEntity.new(entity)
  end
  
  def send_entities_to(client_id)
    @entities.each do |entity|
      @network.send_tcp_message_to client_id , CreateEntity.new(entity)
    end
  end
  
  def create_player(client_id)
    @entities << BasePlayer.new(client_id , @map.next_starting_position)
    @network.send_tcp_message_to client_id , RequestName.new
  end
  
  def create_entity(entity_class , *initialization_arguments)
    entity = entity_class.new *initialization_arguments
    @entities << entity
    broadcast_new_entity entity
  end
  
  def current_player
    @entities.find_player_by_client_id current_turn_client_id
  end
  
  def make_host(player)
    player.host = true
    @host       = player
    @host.ready = true
    @network.send_tcp_message_to player.client_id , RequestStart.new(client_id: player.client_id)
    @network.send_tcp_message_to player.client_id , ReadyToStart.new(client_id: player.client_id)
  end
  
  def initialize_zombies
    Settings.runners.times {self.create_entity BaseRunner , @map.next_zombie_position}
  end
end
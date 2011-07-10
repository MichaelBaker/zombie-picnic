class ServerZombieTurn
  include State
  
  def initialize(game)
    @game    = game
    @map     = game.map
    @zombies = @game.entities.zombies
    @zombies.each &:reset_movement_points
  end
  
  def move_zombies
    while @zombies.any? {|zombie| zombie.can_move? @map}
      @zombies.each do |zombie|
        zombie.move @game
        @game.network.broadcast_tcp_message UpdateEntityAttribute.new(zombie , :position)
        sleep 0.035
      end
    end
    
    @zombies.each &:reset_movement_points
  end
end

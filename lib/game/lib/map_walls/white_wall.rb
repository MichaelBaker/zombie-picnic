class BaseWhiteWall
  attr_accessor :direction , :position
  
  def initialize(position , direction)
    @position  = position
    @direction = direction
  end
end

class ClientWhiteWall < BaseWhiteWall
  attr_reader :image , :draw_position
  
  def initialize(position , direction)
    super position , direction
    
    if direction == :up || direction == :down
      @image = Images[:white_wall_horizontal]
    else
      @image = Images[:white_wall_vertical]
    end
    
    set_draw_position
  end

private

  def adjusted_x
    if @direction == :left
      @position.x - 1.0
    elsif @direction == :right
      @position.x
    elsif @direction == :up
      @position.x - 0.5
    elsif @direction == :down
      @position.x - 0.5
    else
      @position.x
    end
  end

  def adjusted_y
    if @direction == :up
      @position.y - 1.0
    elsif @direction == :down
      @position.y + 0.25
    elsif @direction == :left
      @position.y - 0.5
    elsif @direction == :right
      @position.y - 0.5
    else
      @position.y
    end
  end

  def set_draw_position
    @draw_position = Vector.new adjusted_x , adjusted_y
  end
end
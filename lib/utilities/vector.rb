class Vector
  attr_accessor :x , :y
  
  def initialize(x , y)
    @x = x.to_f
    @y = y.to_f
  end
  
  def hash
    [@x , @y].hash
  end
  
  def eql?(other)
    @x == other.x && @y == other.y
  end
  
  def up(distance = 1)
    self.class.new(@x , @y - distance)
  end
  
  def down(distance = 1)
    self.class.new(@x , @y + distance)
  end
  
  def left(distance = 1)
    self.class.new(@x - distance , @y)
  end
  
  def right(distance = 1)
    self.class.new(@x + distance , @y)
  end
  
  def ==(other)
    @x == other.x && @y == other.y
  end
  
  def distance_to(other)
    (@x - other.x).abs + (@y - other.y).abs
  end
  
  def to_s
    "<Vector x:#{@x} y:#{@y}>"
  end
end
class Walls
  include Enumerable
  
  def initialize
    @first  = Hash.new
    @second = Hash.new
  end
  
  def add(wall)
    @first[wall.first]   = wall
    @second[wall.second] = wall
  end
  
  def each
    @first.values.each { |wall| yield wall }
  end
  
  def [](vector)
    @first[vector] || @second[vector]
  end
end
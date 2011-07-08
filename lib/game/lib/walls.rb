class Walls
  include Enumerable
  
  def initialize
    @first  = Hash.new { |hash , key| hash[key] = Array.new }
    @second = Hash.new { |hash , key| hash[key] = Array.new }
  end
  
  def add(wall)
    @first[wall.first]   << wall
    @second[wall.second] << wall
  end
  
  def each
    @first.values.flatten.each { |wall| yield wall }
  end
  
  def [](vector)
    @first[vector] || @second[vector]
  end
end
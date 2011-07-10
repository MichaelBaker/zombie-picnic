class Walls
  include Enumerable
  
  def initialize
    @first  = Hash.new
    @second = Hash.new
  end
  
  def add(wall)
    @first[wall.first.x] ||= Hash.new
    @first[wall.first.x][wall.first.y] ||= Array.new
    @first[wall.first.x][wall.first.y] << wall
    
    @second[wall.second.x] ||= Hash.new
    @second[wall.second.x][wall.second.y] ||= Array.new
    @second[wall.second.x][wall.second.y] << wall
  end
  
  def each
    @first.values.map{|hash| hash.values}.flatten.each { |wall| yield wall }
  end
  
  def at(x , y)
    results = []
    
    if @first[x] && @first[x][y]
      results.concat @first[x][y]
    end
    
    if @second[x] && @second[x][y]
      results.concat @second[x][y]
    end
    
    results
  end
end
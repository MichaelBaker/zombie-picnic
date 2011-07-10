module FieldOfView
  def visible_vectors(start , edges)
    visible = []
    edges.each do |edge_vector|
      tile_line(start , edge_vector).each do |vector|
        dx = (start.x - vector.x)
        dy = (start.y - vector.y)

        dy = dy == 0 ? 0 : dy/dy.abs
        dx = dx == 0 ? 0 : dx/dx.abs

        bx , by = vector.x , vector.y + dy
        cx , cy = vector.x + dx , vector.y
        
        if blocked?(vector.x , vector.y , start) || 
           (blocked?(bx , by , start) && blocked?(cx , cy , start))
          break
        else
          visible << vector unless visible.include? vector
        end
      end
    end
    visible
  end
  
  def blocked?(x0 , y0 , start)
    @walls.at(x0 , y0).any? do |wall|
      (wall.position.x < x0 && start.x < wall.position.x) ||
      (wall.position.x > x0 && start.x > wall.position.x) ||
      (wall.position.y < y0 && start.x < wall.position.y) ||
      (wall.position.y > y0 && start.x > wall.position.y)
    end
  end
  
  def tile_line(a , b)
    a = Vector.new(a.x , a.y)
    b = Vector.new(b.x , b.y)
    
    visible = []
    dx      = (b.x - a.x).abs
    dy      = (b.y - a.y).abs

    sx = a.x < b.x ? 1 : -1
    sy = a.y < b.y ? 1 : -1

    err = dx - dy

    until a.x == b.x && a.y == b.y
      visible << Vector.new(a.x , a.y)

      e2 = 2 * err

      if e2 > -dy
        err = err - dy
        a.x = a.x + sx
      end

      if e2 < dx
        err = err + dx
        a.y = a.y + sy 
      end
    end
    
    visible
  end
end

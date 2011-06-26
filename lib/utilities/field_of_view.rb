module FieldOfView
  #  Start with:
  #    sight range
  #    light origin
  #    starting slope
  #    ending slope
  #
  #  Scan the octant in the relevant direction
  #  If      the tile is beyond the range, return
  #  Else If the tile is on the ending slope, add it to the list and start at the next row/column with the same slopes
  #  Else If the tile is clear, add it to the list and go to the next column/row
  #  Else    start a new scan with the same starting slope, but an ending slope on the current tile
  #          then scan until you find a clear tile or the end
  #          If a clear tile is found
  #            start a new scan with it as the starting slope and the ending slope as with the next blocked tile or the end
  #
  #            Shared
  #            edge by
  # Shared     1 & 2      Shared
  # edge by\      |      /edge by
  # 1 & 8   \     |     / 2 & 3
  #          \1111|2222/
  #          8\111|222/3
  #          88\11|22/33
  #          888\1|2/333
  # Shared   8888\|/3333  Shared
  # edge by-------@-------edge by
  # 7 & 8    7777/|\4444  3 & 4
  #          777/6|5\444
  #          77/66|55\44
  #          7/666|555\4
  #          /6666|5555\
  # Shared  /     |     \ Shared
  # edge by/      |      \edge by
  # 6 & 7      Shared     4 & 5
  #            edge by 
  #            5 & 6
  #
  #Fig.4a Area of coverage by each octant
  
  # Multipliers for transforming coordinates into other octants
      @@mult = [
                  [1,  0,  0, -1, -1,  0,  0,  1],
                  [0,  1, -1,  0,  0, -1,  1,  0],
                  [0,  1,  1,  0,  0, -1, -1,  0],
                  [1,  0,  0,  1, -1,  0,  0, -1],
               ] 

      # Determines which co-ordinates on a 2D grid are visible
      # from a particular co-ordinate.
      # start_x, start_y: center of view
      # radius: how far field of view extends
      def do_fov(start_x, start_y, radius)
          positions = [Vector.new(start_x, start_y)]
          
          8.times do |oct|
              cast_light start_x, start_y, 1, 1.0, 0.0, radius,
                  @@mult[0][oct],@@mult[1][oct],
                  @@mult[2][oct], @@mult[3][oct], 0 , positions
          end
          
          positions
      end

      private
      # Recursive light-casting function
      def cast_light(cx, cy, row, light_start, light_end, radius, xx, xy, yx, yy, id , positions)
          return if light_start < light_end
          radius_sq = radius * radius
          (row..radius).each do |j| # .. is inclusive
              dx, dy = -j - 1, -j
              blocked = false
              while dx <= 0
                  dx += 1
                  # Translate the dx, dy co-ordinates into map co-ordinates
                  mx, my = cx + dx * xx + dy * xy, cy + dx * yx + dy * yy
                  # l_slope and r_slope store the slopes of the left and right
                  # extremities of the square we're considering:
                  l_slope, r_slope = (dx-0.5)/(dy+0.5), (dx+0.5)/(dy-0.5)
                  if light_start < r_slope
                      next
                  elsif light_end > l_slope
                      break
                  else
                      # Our light beam is touching this square; light it
                      unless blocked?(mx, my)
                        positions << Vector.new(mx, my) if (dx*dx + dy*dy) < radius_sq
                      end
                      if blocked
                          # We've scanning a row of blocked squares
                          if blocked?(mx, my)
                              new_start = r_slope
                              next
                          else
                              blocked = false
                              light_start = new_start
                          end
                      else
                          if blocked?(mx, my) and j < radius
                              # This is a blocking square, start a child scan
                              blocked = true
                              cast_light(cx, cy, j+1, light_start, l_slope,
                                  radius, xx, xy, yx, yy, id+1 , positions)
                              new_start = r_slope
                          end
                      end
                  end
              end # while dx <= 0
              break if blocked
          end # (row..radius+1).each
      end
      
      # MAKE THIS CORRECT AND FIX VECTOR/HASH DISCREPENCY
      def blocked?(x , y)
        vector = Vector.new(x , y)
        tile_at(vector).nil? || walls_at({x: x , y: y}).any?
      end
end

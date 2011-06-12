module Renderer
  def draw
    if @map
      draw_map
      draw_tile_highlights
      draw_walls
      draw_entities
    end
      
    draw_ui
  end
  
private

  def draw_walls
    @map.walls.each do |wall|
      wall.each do |section|
        section.image.draw section.image.width  * section.draw_position.x, 
                           section.image.height * section.draw_position.y , 1
      end
    end
  end
  
  def draw_tile_highlights
    draw_movment_highlights
  end
  
  def draw_movment_highlights
    @entities.players.each do |player|      
      @map.reachable_tiles(player).each do |tile|
        if player.client_id == current_player_client_id
          highlighter = :walk_highlight
        else
          highlighter = :other_player_walk_highlight
        end
        
        Images[highlighter].draw tile.position.x * 50 , tile.position.y * 50 , 1
      end
    end
  end
  
  def draw_selected_tile_highlight
    x = mouse_x - (mouse_x % 50)
    y = mouse_y - (mouse_y % 50)
    Images[:tile_highlight].draw x , y , 50
  end
  
  def draw_entities
    @entities.each do |entity|
      entity.image.draw entity.position.x * entity.image.width , entity.position.y * entity.image.height , 1
    end
  end
  
  def draw_map
    @map.tiles.each do |tile|
      tile.image.draw tile.position.x * tile.image.width , tile.position.y * tile.image.height , 1
    end
  end
end
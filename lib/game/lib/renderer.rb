module Renderer
  def draw
    if @map
      draw_map
      draw_tile_highlights
      draw_entities
    end
      
    draw_ui
  end
  
private

  def draw_tile_highlights
    draw_movment_highlights
    draw_selected_tile_highlight
  end
  
  def draw_movment_highlights
    @entities.players.each do |player|      
      @map.tiles_in_range(player.position , player.speed).each do |tile|
        if player.client_id == current_player_client_id
          Images[:walk_highlight].draw tile.x * 50 , tile.y * 50 , 1 if tile
        else
          Images[:other_player_walk_highlight].draw tile.x * 50 , tile.y * 50 , 1 if tile
        end
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
      entity.image.draw entity.position[:x] * entity.image.width , entity.position[:y] * entity.image.height , 1
    end
  end
  
  def draw_map
    @map.tiles.each do |tile|
      tile.image.draw tile.x * tile.image.width , tile.y * tile.image.height , 1
    end
  end
end
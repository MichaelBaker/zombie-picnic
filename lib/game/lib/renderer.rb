module Renderer
  def draw
    if @map
      draw_map
      draw_tile_highlights
      draw_entities
      draw_walls
    end
      
    draw_ui
  end
  
private

  def draw_walls
    @map.walls.each do |wall|
      wall.each do |section|
        image = section.image
        
        x = (section.draw_position.x - section.draw_position.y) * 50 + section.draw_position.y
        y = (section.draw_position.x + section.draw_position.y) * (50 / 2.0) + section.draw_position.y
        
        section.image.draw x , y , 1
      end
    end
  end
  
  def draw_tile_highlights
    draw_movment_highlights
  end
  
  def draw_movment_highlights
    @entities.players.each do |player|
      @map.reachable_tiles(player).each do |tile|
        x = (tile.position.x - tile.position.y) * 50 + tile.position.y
        y = (tile.position.x + tile.position.y) * (50 / 2.0) + tile.position.y
        
        if player.client_id == current_player_client_id
          highlighter = :walk_highlight
        else
          highlighter = :other_player_walk_highlight
        end
        
        Images[highlighter].draw x , y , 1
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
      image = entity.image
      
      x = (entity.position.x - entity.position.y) * image.height + entity.position.y
      y = (entity.position.x + entity.position.y) * (image.height / 2.0) + entity.position.y
      
      entity.image.draw x , y , 1
    end
  end
  
  def draw_map
    @map.tiles.each do |tile|
      image = tile.image
      
      x = (tile.position.x - tile.position.y) * image.height + tile.position.y
      y = (tile.position.x + tile.position.y) * (image.height / 2.0) + tile.position.y
      
      tile.image.draw x , y , 1
    end
  end
end
module Renderer
  TileWidth  = 100
  TileHeight = 50
  
  def draw
    if @map
      draw_map
      draw_tile_highlights
      draw_entities
      draw_walls
      draw_debug
      Images[:directions].draw 1000 , 0 , 1
    end
      
    draw_ui
  end
  
  def draw_debug
    player = @entities.find_player_by_client_id @my_client_id
    
    @map.do_fov(player.position.x, player.position.y, 8).each do |position|
      x = (position.x - position.y) * TileHeight + position.y
      y = (position.x + position.y) * (TileHeight / 2.0) + position.y
      
      Images[:debug].draw x - viewport.x , y - viewport.y , 1
    end
  end
  
  def move_viewport(direction)
    amount = 50
    
    case direction
    when :up
      viewport.y -= amount
    when :down
      viewport.y += amount
    when :left
      viewport.x -= amount
    when :right
      viewport.x += amount
    end
  end
  
private

  def viewport
    @viewport ||= Vector.new 0 , 0
  end

  def draw_walls
    @map.walls.each do |wall|
      wall.each do |section|
        image = section.image
        
        x = (section.draw_position.x - section.draw_position.y) * TileHeight + section.draw_position.y
        y = (section.draw_position.x + section.draw_position.y) * (TileHeight / 2.0) + section.draw_position.y
        
        section.image.draw x - viewport.x , y - viewport.y , 1
      end
    end
  end
  
  def draw_tile_highlights
    draw_movment_highlights
  end
  
  def draw_movment_highlights
    @entities.players.each do |player|
      @map.reachable_tiles(player).each do |tile|
        x = (tile.position.x - tile.position.y) * TileHeight + tile.position.y
        y = (tile.position.x + tile.position.y) * (TileHeight / 2.0) + tile.position.y
        
        if player.client_id == current_player_client_id
          highlighter = :walk_highlight
        else
          highlighter = :other_player_walk_highlight
        end
        
        Images[highlighter].draw x - viewport.x , y - viewport.y , 1
      end
    end
  end
  
  def draw_entities
    @entities.each do |entity|
      x = (entity.position.x - entity.position.y) * TileHeight + entity.position.y
      y = (entity.position.x + entity.position.y) * (TileHeight / 2.0) + entity.position.y
      
      entity.image.draw(x - viewport.x , y - viewport.y + (50 - entity.image.height) , 1)
    end
  end
  
  def draw_map
    @map.tiles.each do |tile|
      image = tile.image
      
      x = (tile.position.x - tile.position.y) * TileHeight + tile.position.y
      y = (tile.position.x + tile.position.y) * (TileHeight / 2.0) + tile.position.y
      
      tile.image.draw x - viewport.x , y - viewport.y + (50 - image.height) , 1
    end
  end
end
class ShallotUI::ShallotUIClass
  def initialize(window)
    @window = window
    clear
  end
  
  def layers
    @layers.values.sort
  end
  
  def add_layer(options = {})
    merge_layer_options! options

    @layers[options[:id].to_sym] = ShallotUI::ShallotLayer.new(@window , options)
  end
  
  def [](id)
    @layers[id.to_sym] || find_widget_by_id(id)
  end
  
  def find_widget_by_id(id)
    id = id.to_sym
    layers.each {|layer| return layer[id] if layer[id]}
  end
  
  def add_widget(widget)
    self[:layer_0] << widget
  end
  
  def draw
    layers.each {|layer| layer.draw}
  end
  
  private
  
  def merge_layer_options!(options)
    index = options[:z_index] || next_layer_index

    options[:z_index] ||= index
    options[:id]      ||= "layer_#{index}".to_sym
  end
  
  def next_layer_index
    layers.last.z_index + 1
  end
  
  def clear
    @layers = Hash.new
    add_layer z_index: 100 , id: :layer_0
  end
end
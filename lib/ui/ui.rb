module ShallotUI
  class ShallotLayer
    attr_reader :id , :z_index
    
    def initialize(options)
      @id      = options[:id]
      @z_index = options[:z_index]
    end
  end
  
  def render_shallot_ui
    
  end
  
  def ui_layers
    @_shallot_ui_layers ||= [ShallotLayer.new(z_index: 0)]
  end
  
  def add_layer(options = {})
    _merge_layer_options! options
    
    ui_layers[options[:z_index]] = ShallotLayer.new options
  end

private
  def _merge_layer_options!(options)
    index = options[:z_index] || next_layer_index
    
    options[:z_index] ||= index
    options[:id]      ||= "layer_#{index}".to_sym
  end
  
  def _next_layer_index
    ui_layers.last.z_index + 1
  end
end

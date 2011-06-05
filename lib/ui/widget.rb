class ShallotUI::Widgets::Widget
  attr_accessor :x , :y , :id
  
  def initialize(options = {})
    merge_default_options! options
    
    @x          = options[:x]
    @y          = options[:y]
    @id         = options[:id].to_sym
  end
  
  def merge_default_options!(options)
    options[:x]  ||= 0
    options[:y]  ||= 0
    options[:id] ||= "no id"
  end
  
  def window=(window)
    create_image window
  end
  
  def create_image(window)
  end
end

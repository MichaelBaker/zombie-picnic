class ShallotUI::Widget
  def initialize(options)
    merge_default_options! options
    
    @x = options[:x]
    @y = options[:y]
  end
  
  def merge_default_options!(options)
    options[:x] ||= 0
    options[:y] ||= 0
  end
  
  def window=(window)
    create_image window
  end
  
  def create_image(window)
  end
end
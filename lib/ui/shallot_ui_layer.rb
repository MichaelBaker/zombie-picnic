class ShallotUI::ShallotLayer
  include Comparable
  
  attr_accessor :id , :z_index
  
  def initialize(window , options)
    @window  = window
    @id      = options[:id]
    @z_index = options[:z_index]
    @widgets = Hash.new
  end
  
  def widgets
    @widgets.values
  end
  
  def <=>(other)
    @z_index <=> other.z_index
  end
  
  def <<(widget)
    widget.window       = @window
    @widgets[widget.id] = widget
  end
  
  def [](id)
    @widgets[id]
  end
  
  def draw
    widgets.each {|widget| widget.draw(@z_index)}
  end
end

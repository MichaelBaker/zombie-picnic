class ShallotUI::ShallotLayer
  extend Forwardable
  include Comparable
  
  attr_accessor  :widgets , :id , :z_index
  def_delegators :@widgets , :remove
  
  def initialize(window , options)
    @window  = window
    @id      = options[:id]
    @z_index = options[:z_index]
    @widgets = Array.new
  end
  
  def <=>(other)
    @z_index <=> other.z_index
  end
  
  def <<(widget)
    widget.window = @window
    @widgets << widget
  end
  
  def draw
    @widgets.each {|widget| widget.draw}
  end
end
class ShallotUI::Widgets::TextWidget < ShallotUI::Widgets::Widget
  attr_reader :text
  
  def initialize(text , options = {})
    super options
    @text = text.to_s
  end
  
  def create_image(window)
    @window = window
    render_text
  end
  
  def draw(z_index)
    @image.draw(@x , @y , z_index) if @image
  end
  
  def text=(text)
    @text = text.to_s
    render_text
  end
  
  private
  
  def render_text
    @image = Image.from_text(@window , text , "Arial" , 24)
  end
end
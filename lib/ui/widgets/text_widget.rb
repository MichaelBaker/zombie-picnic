class ShallotUI::TextWidget < ShallotUI::Widget
  def initialize(text , options = {})
    super options
    @text = text
  end
  
  def create_image(window)
    @image = Image.from_text(window , @text , "Arial" , 24)
  end
  
  def draw(z_index)
    @image && @image.draw(@x , @y , z_index)
  end
end
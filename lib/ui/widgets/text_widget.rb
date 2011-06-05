class ShallotUI::Widgets::TextWidget < ShallotUI::Widgets::Widget
  attr_reader :text
  
  def initialize(text , options = {})
    super options
    @text             = text.to_s
    @background_color = options[:background]
  end
  
  def create_image(window)
    @window = window
    render_text
  end
  
  def draw(z_index)
    @image.draw @x , @y , z_index if @image
  end
  
  def text=(text)
    @text = text.to_s
    render_text
  end
  
  private
  
  def render_text
    text_image = Image.from_text(@window , text , "Arial" , 24)
    
    if @background_color
      @image = render_background text_image.width , text_image.height
      @image.splice text_image , 0 , 0 , chroma_key: :alpha
    else
      @image = text_image
    end
  end
  
  def render_background(width , height)
    image = TexPlay.create_blank_image @window , width , height
    image.rect 0 , 0 , image.width , image.height , color: @background_color , fill: true
  end
end

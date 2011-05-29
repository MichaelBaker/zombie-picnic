class Images
  def self.load(surface)
    @@images = Hash.new
    
    Dir.glob(File.dirname(__FILE__) + "/../../../assets/images/*.png").each do |filename|
      tilename           = File.basename(filename).split(".")[0]
      @@images[tilename.to_sym] = Image.new surface , filename , false
    end
  end
  
  def self.[](image_name)
    @@images[image_name.to_sym]
  end
end

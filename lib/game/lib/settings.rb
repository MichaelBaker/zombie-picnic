class Settings
  def self.load(file_path)
    hash = YAML::load_file File.expand_path(file_path)
    
    hash.each do |setting , value|
      define_singleton_method setting do
        value
      end
    end
  end
end
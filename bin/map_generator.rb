File.open File.dirname(__FILE__) + "/../assets/maps/map.map" , "w" do |file|
  file.puts ":tiles:"

  (0...16).each do |row|
    (0...25).each do |column|
      file.puts "  -"
      file.puts "    :x: #{column}"
      file.puts "    :y: #{row}"
      file.puts "    :type: #{rand < 0.1 ? ":water" : ":grass"}"
    end
  end
end
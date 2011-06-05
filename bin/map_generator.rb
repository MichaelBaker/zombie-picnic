File.open File.dirname(__FILE__) + "/../assets/maps/map.map" , "w" do |file|
  file.puts ":tiles:"

  (0...20).each do |row|
    (0...32).each do |column|
      file.puts "  -"
      file.puts "    :x: #{column}"
      file.puts "    :y: #{row}"
      file.puts "    :type: #{rand < 0.3 ? ":water" : ":grass"}"
    end
  end
end
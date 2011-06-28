desc "Generate a random map file"
namespace :generate do
  task :map do
    File.open(File.dirname(__FILE__) + "/assets/maps/map.map") , "w" do |file|
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
  end
end

desc "Run the test suite"
task :test do
  require "minitest/autorun"
  Dir.glob(File.dirname(__FILE__) + "/tests/*.rb").shuffle.each do |filepath|
    system %Q(ruby -r "minitest/autorun" #{filepath})
  end
end
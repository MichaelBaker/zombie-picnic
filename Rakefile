desc "Generate a random map file"
namespace :generate do
  task :map do
    `ruby ./bin/map_generator.rb`
  end
end

desc "Run the test suite"
task :test do
  require "minitest/autorun"
  Dir.glob(File.dirname(__FILE__) + "/tests/*.rb").shuffle.each do |filepath|
    system %Q(ruby -r "minitest/autorun" #{filepath})
  end
end
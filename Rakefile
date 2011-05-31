desc "Generate a random map file"
namespace :generate do
  task :map do
    `ruby ./bin/map_generator.rb`
  end
end

desc "Run the test suite"
task :test do
  Dir.glob(File.dirname(__FILE__) + "/tests/*.rb").each { |filepath| system "ruby #{filepath}" }
end
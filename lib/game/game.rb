require "gosu"
include Gosu

Dir.glob(File.dirname(__FILE__) + "/lib/states/*.rb").each {|filename| require_relative filename}

require_relative "../ui/ui"
require_relative "./lib/message_queue"
require_relative "./lib/map"
require_relative "./lib/entities"
require_relative "./lib/player"
require_relative "./lib/server.rb"
require_relative "./lib/client.rb"
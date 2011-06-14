require "gosu"
require "texplay"

include Gosu

require_relative "./lib/state"
Dir.glob(File.dirname(__FILE__) + "/lib/states/*.rb").each {|filename| require_relative filename}

require_relative "./lib/map"
Dir.glob(File.dirname(__FILE__) + "/lib/map_walls/*.rb").each {|filename| require_relative filename}
Dir.glob(File.dirname(__FILE__) + "/lib/map_tiles/*.rb").each {|filename| require_relative filename}

require_relative "./lib/entities"
require_relative "./lib/entities/entity"
require_relative "./lib/entities/zombie"
Dir.glob(File.dirname(__FILE__) + "/lib/entities/*.rb").each {|filename| require_relative filename}

require_relative "../ui/ui"
include ShallotUI::Widgets

require_relative "./lib/settings"
require_relative "./lib/message_queue"
require_relative "./lib/renderer"
require_relative "./lib/server.rb"
require_relative "./lib/client.rb"
require "gosu"
include Gosu

require_relative "./lib/state"
Dir.glob(File.dirname(__FILE__) + "/states/*.rb").each {|filename| require_relative filename}

require_relative "../ui/ui"
include ShallotUI::Widgets

require_relative "./lib/message_queue"
require_relative "./lib/map"
require_relative "./lib/entities"
require_relative "./lib/player"
require_relative "./lib/server.rb"
require_relative "./lib/client.rb"
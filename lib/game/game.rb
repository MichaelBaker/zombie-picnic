require "gosu"
require "texplay"

include Gosu

require "game/lib/state"
require "game/lib/walls"
require "game/lib/map"
require "game/lib/renderer"
require "ui/ui"
require "game/lib/entities/zombie"

include ShallotUI::Widgets

Dir.glob(File.expand_path "**/*.rb" , File.dirname(__FILE__)).each {|filename| require filename}
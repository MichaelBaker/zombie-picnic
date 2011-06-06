#!/usr/bin/env ruby

require "yaml"

Dir.glob(File.dirname(__FILE__) + "/../lib/utilities/*.rb").each {|path| require_relative path}

require_relative "../lib/network/game-networking"
require_relative "../lib/game/game"

Settings.load(File.dirname(__FILE__) + "/settings.yml")

network = GameServer.new Settings.port
game    = ServerWindow.new network
game.load_map "map"

game.start
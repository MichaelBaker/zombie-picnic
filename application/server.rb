#!/usr/bin/env ruby

require "yaml"

require_relative "../lib/network/game-networking"
require_relative "../lib/game/game"

settings = YAML::load_file File.dirname(__FILE__) + "/settings.yml"

network = GameServer.new settings[:port]
game    = ServerWindow.new network
game.load_map "map"

game.start
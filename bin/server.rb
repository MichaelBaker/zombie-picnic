#!/usr/bin/env ruby

require "yaml"

$LOAD_PATH << File.expand_path("../lib" , File.dirname(__FILE__))

require "utilities/utilities"
require "network/game-networking"
require "game/game"

Settings.load(File.dirname(__FILE__) + "/settings.yml")

network = GameServer.new Settings.port
game    = ServerWindow.new network
game.load_map "map"
game.initialize_zombies

game.start
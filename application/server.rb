#!/usr/bin/env ruby

require_relative "../lib/network/game-networking"
require_relative "../lib/game/game"

network = GameServer.new 8337 , 8338
game    = ServerWindow.new network
game.load_map "map"

game.start
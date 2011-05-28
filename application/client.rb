#!/usr/bin/env ruby

require_relative "../lib/network/game-networking"
require_relative "../lib/game/game"

network = GameClient.new "localhost" , 8337 , 8338
game    = ClientWindow.new network

game.start
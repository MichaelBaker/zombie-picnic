#!/usr/bin/env ruby

require_relative "../lib/network/game-networking"
require_relative "../lib/game/game"
require_relative "../lib/game/lib/images"

network = GameClient.new "localhost" , 8337
game    = ClientWindow.new network

Images.load game

game.start
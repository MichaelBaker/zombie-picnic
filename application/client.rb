#!/usr/bin/env ruby

require "yaml"

require_relative "../lib/network/game-networking"
require_relative "../lib/game/game"
require_relative "../lib/game/lib/images"

settings = YAML::load_file File.dirname(__FILE__) + "/settings.yml"

network = GameClient.new settings[:ip] , settings[:port]
game    = ClientWindow.new network , settings[:name]

Images.load game

game.start
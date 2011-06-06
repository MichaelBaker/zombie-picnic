#!/usr/bin/env ruby

require "yaml"

Dir.glob(File.dirname(__FILE__) + "/../lib/utilities/*.rb").each {|path| require_relative path}

require_relative "../lib/network/game-networking"
require_relative "../lib/game/game"
require_relative "../lib/game/lib/images"

Settings.load(File.dirname(__FILE__) + "/settings.yml")

network = GameClient.new Settings.ip , Settings.port
game    = ClientWindow.new network , Settings.name , Settings.fullscreen

Images.load game

game.start
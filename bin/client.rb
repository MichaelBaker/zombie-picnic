#!/usr/bin/env ruby

require "yaml"

$LOAD_PATH << File.expand_path("../lib" , File.dirname(__FILE__))

require "utilities/utilities"
require "network/game-networking"
require "game/game"
require "game/lib/images"

Settings.load(File.dirname(__FILE__) + "/settings.yml")

network = GameClient.new Settings.ip , Settings.port
game    = ClientWindow.new network , Settings.name , Settings.fullscreen

Images.load game

game.start
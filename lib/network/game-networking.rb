require "bundler/setup"
require "eventmachine"

require_relative "../callback/callback"
require_relative "./lib/TCPHandler"
require_relative "./lib/command_messages"

Dir.glob(File.dirname(__FILE__) + "/messages/*.rb").each {|filename| require_relative filename}

require_relative "./lib/server"
require_relative "./lib/client"
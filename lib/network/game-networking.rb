require "eventmachine"

require "callback/callback"
require "network/lib/tcp_handler"
require "network/lib/command_messages"
require "network/lib/server"
require "network/lib/client"

Dir.glob(File.expand_path "messages/*" , File.dirname(__FILE__)).each {|path| require path}
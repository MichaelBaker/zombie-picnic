require "thread"

class MessageQueue
  def initialize
    @semaphore = Mutex.new
    @messages  = Array.new
  end
  
  def <<(message)
    @semaphore.synchronize {
      @messages << message
    }
  end
  
  def each(&block)
    if @semaphore.try_lock
      @messages.each &block
      @messages.clear
      @semaphore.unlock
    end
  end
end
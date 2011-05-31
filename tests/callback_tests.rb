require "minitest/autorun"
require_relative "../lib/callback/callback"

describe Callback do
  before do
    class Test
      include Callback
    end
    
    @t = Test.new
  end
  
  it "should allow event handlers to be placed on a class" do
    @t.on :whatever do puts "something" end
  end
  
  it "should run all of the placed callbacks when the event is emitted" do
    s = "test"
    f = "test"
    
    @t.on :whatever do s = "called" end
    @t.on :whatever do f = "called" end
    
    @t.emit :whatever
    
    assert_equal s , "called"
    assert_equal f , "called"
  end
end
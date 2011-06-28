require "game/lib/state"

class TestState
  include State
end

class TestMessage
  attr_accessor :content
end

describe State do
  before do
    @state   = TestState.new
    @message = TestMessage.new
  end
  
  it "should have a handle class method that registers a callback for a given message" do
    class TestState
      handle TestMessage do
        # Something
      end
    end
  end
  
  it "should have a handle_message method that will run the correct callback" do
    class TestState
      handle TestMessage do
        5
      end
    end
    
    assert_equal 5 , @state.handle_message(@message)
  end
  
  it "should make the message being handled available in the handler implicitly" do
    class TestState
      handle TestMessage do
        "test - #{message.content}"
      end
    end
    
    @message.content = "asldfja#{rand};lskjf;ashdf"
    
    assert_equal "test - #{@message.content}" , @state.handle_message(@message)
  end
  
  it "should support before handlers to run before a message is handled" do
    class TestState
      before do
        @before_var ||= 0
        @before_var += 1
      end
      
      handle TestMessage do
        "#{@before_var} - #{message.content}"
      end
    end
    
    @message.content = "a"
    
    assert_equal "1 - a" , @state.handle_message(@message)
    assert_equal "2 - a" , @state.handle_message(@message)
    assert_equal "3 - a" , @state.handle_message(@message)
  end
end
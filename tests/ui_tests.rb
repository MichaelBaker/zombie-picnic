require "minitest/autorun"
require "gosu"
require_relative "../lib/ui/ui"

describe ShallotUI do
  before do
    class TestMock < MiniTest::Mock
      include ShallotUI
    end
    
    @window = TestMock.new
  end
  
  it "should be drawable from within the window" do
    assert @window.respond_to?(:render_shallot_ui)
  end
  
  it "should have drawing layers" do
    assert_equal @window.ui_layers.size , 1
  end
  
  it "should be able to create new layers with z-indecies and ids" do
    @window.add_layer z_index: 1 , id: "second_layer"
    assert_equal @window.ui_layers.size , 2
  end
  
  it "should be able to add a text widget without an explicit layer" do
    false
  end
end
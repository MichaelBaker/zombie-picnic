require "gosu"
require "ui/ui"

describe ShallotUI do
  before do
    class TestMock < MiniTest::Mock
      include ShallotUI
    end
    
    @window = TestMock.new
    @widget = ShallotUI::Widgets::Widget.new
  end
  
  it "should be drawable from within the window" do
    assert @window.respond_to?(:draw_ui)
  end
  
  it "should have drawing layers" do
    assert_equal @window.ui.layers.size , 1
  end
  
  it "should be able to create new layers with z-indecies and ids" do
    @window.ui.add_layer z_index: 1 , id: "second_layer"
    assert_equal @window.ui.layers.size , 2
  end
  
  it "should add layers to the next highest z_index if none is provided" do
    @window.ui.add_layer id: "test"
    assert_equal 101 , @window.ui[:test].z_index
    
    @window.ui.add_layer id: "test2"
    assert_equal 102 , @window.ui[:test2].z_index
  end
  
  it "should make its layers accessable via their id" do
    assert @window.ui[:layer_0]
    assert @window.ui["layer_0"]
  end
  
  it "should add new widgets to layer 0 if they aren't added to a specific layer" do
    @window.ui.add_widget @widget
    
    assert_equal 1 , @window.ui[:layer_0].widgets.size
  end
end
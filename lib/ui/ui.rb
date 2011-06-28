require "forwardable"

module ShallotUI
  def draw_ui
    ui.draw
  end
  
  def ui
    @_shallot_ui ||= ShallotUIClass.new(self)
  end
  
  def add_widget(widget)
    ui.add_widget widget
  end
  
  def clear_ui
    ui.clear
  end
  
  module Widgets
  end
end

require "ui/shallot_ui_layer"
require "ui/shallot_ui_class"
require "ui/widget"
Dir.glob(File.expand_path "widgets/*" , File.dirname(__FILE__)).each {|filepath| require filepath}

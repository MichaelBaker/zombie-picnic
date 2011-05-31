require "forwardable"

module ShallotUI
  def draw_ui
    ui.draw
  end
  
  def ui
    @_shallot_ui ||= ShallotUIClass.new(self)
  end
end

require_relative "./shallot_ui_layer"
require_relative "./shallot_ui_class"
Dir.glob(File.dirname(__FILE__) + "/widgets/*.rb").each {|filepath| require_relative filepath}

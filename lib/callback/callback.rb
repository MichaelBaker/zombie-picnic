module Callback
  def on(name , &callback)
    _callbacks_for(name) << callback
  end
  
  def emit(*arguments)
    _callbacks_for(arguments[0]).each {|callback| callback.call *(arguments[1..-1])}
  end

private

  def _callbacks
    @_callbacks ||= Hash.new {|hash , key| hash[key] = Array.new}
  end
  
  def _callbacks_for(name)
    _callbacks[name]
  end
end
module State
  def self.included(base_class)
    base_class.class_variable_set "@@_message_handlers" , Hash.new
    base_class.class_variable_set "@@_before_handlers"  , Array.new
    base_class.class_variable_set "@@_default_handler"  , nil
    base_class.extend ClassMethods
  end
  
  def before_handlers
    self.class.class_variable_get "@@_before_handlers"
  end
  
  def message_handlers
    self.class.class_variable_get "@@_message_handlers"
  end
  
  def default_handler
    self.class.class_variable_get "@@_default_handler"
  end
  
  def handle_message(message)
    before_handlers.each {|block| instance_exec message , &block}
    
    if [message.class]
      instance_exec message , &message_handlers[message.class]
    elsif default_handler
      instance_exec message , &default_handler
    end
  end
  
  module ClassMethods
    def message_handlers
      self.class_variable_get "@@_message_handlers"
    end
    
    def before_handlers
      self.class_variable_get "@@_before_handlers"
    end
    
    def handle(message_class , &block)
      message_handlers[message_class] = block
    end

    def before(&block)
      before_handlers << block
    end

    def default(&block)
      self.class_variable_set "@@_default_handler" , block
    end
  end
end
module State
  def button_up(button_id)
  end
  
  def button_down(button_id)
  end
  
  def mouse_click(button_id , x , y)  
  end
  
  def self.included(base_class)
    base_class.class_variable_set "@@_message_handlers" , Hash.new
    base_class.class_variable_set "@@_verify_handlers"  , Hash.new {|hash , key| hash[key] = Array.new}
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
  
  def verify_handlers
    self.class.class_variable_get("@@_verify_handlers")[:all]
  end
  
  def handle_message(message)
    @message = message
    
    verify_handlers.each {|block| return unless instance_exec &block}
    before_handlers.each {|block| instance_exec &block}
    
    if message_handlers[message.class]
      result = instance_exec &message_handlers[message.class]
    elsif default_handler
      result = instance_exec &default_handler
    end
    
    result
  ensure
    @message = nil
  end
  
  def message
    @message
  end
  
  def ignore_message
    @ignore_message = true
  end
  
  module ClassMethods
    def message_handlers
      self.class_variable_get "@@_message_handlers"
    end
    
    def before_handlers
      self.class_variable_get "@@_before_handlers"
    end
    
    def verify_handlers
      self.class_variable_get "@@_verify_handlers"
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
    
    def verify(options = {} , &block)
      verify_handlers[:all] << block
    end
  end
end

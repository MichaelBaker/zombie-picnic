module Entity
  def self.included(base_class)
    base_class.extend ClassMethods
  end
  
  module ClassMethods
    def syncable_attributes(*attributes)
      class_variable_set "@@syncable_attributes" , attributes
      attr_accessor *attributes
    end
  end
  
  def attributes=(attributes)
    attributes.each do |attribute , value|
      self.send "#{attribute}=" , value
    end
  end
  
  def syncable_attributes
    attrs = self.class.class_variable_get "@@syncable_attributes"
    attrs.inject Hash.new do |hash , attribute|
      hash[attribute] = self.send(attribute)
      hash
    end
  end
end
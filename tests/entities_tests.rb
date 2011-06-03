require_relative "../lib/game/lib/entities"

describe Entities do
  before do
    class TestEntity
      attr_accessor :entity_id , :test_item
    end
    
    @entity_one = TestEntity.new
    @entity_two = TestEntity.new
    
    @entities = Entities.new
  end
  
  it "should accept things that have an entity id" do
    @entity_one.entity_id = 4
    @entities << @entity_one
    
    assert @entities.size , 1
  end
  
  it "should produce unique ids" do
    ids = []
    
    100.times {ids.push @entities.next_id}
    
    assert_equal ids.uniq.size , 100
  end
  
  it "should raise an exception if the entity doesn't have an entity_id" do
    exception_raised = false
    
    begin
      @entities << "A string!"
    rescue ArgumentError => e
      exception_raised = true
    end
    
    assert exception_raised
  end
  
  it "should raise an exception if the entity's id isn't set" do
    exception_raised = false
    
    begin
      @entities << @entity_one
    rescue ArgumentError => e
      exception_raised = true
    end
    
    assert exception_raised
  end
  
  it "should be able to iterate over its entitites" do
    @entity_one.entity_id = 1
    @entity_two.entity_id = 2
    
    @entities << @entity_one
    @entities << @entity_two
    
    @entities.each {|entity| entity.test_item = true}
    
    assert @entity_one.test_item == true
    assert @entity_two.test_item == true
  end
  
  it "should maintain a count of its entities" do
    @entity_one.entity_id = 5
    @entity_two.entity_id = 6
    
    @entities << @entity_one
    @entities << @entity_two
    
    assert_equal @entities.size , 2
  end
  
  it "should only maintain one entity with a given id" do
    @entity_one.entity_id = 5
    @entity_two.entity_id = 5
    
    @entities << @entity_one
    @entities << @entity_two
    
    assert_equal @entities.size , 1
  end
end
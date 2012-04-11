require 'spec_helper'

describe "Version" do
  before :each do 
    @version = PaperTrail::Model::DataMapper::Version.new(:item_type => 'Post', :item_id => 1, :whodunnit => "1", :event => "create")
  end
  
  describe "before save" do
    it "should be valid with all attributes given" do
      @version.should be_valid
    end

    it "should not be valid without item type" do
      @version.item_type = nil
      @version.should_not be_valid
    end
    
    it "should not be valid without item id" do
      @version.item_id = nil
      @version.should_not be_valid
    end
    
    it "should not be valid without whodunnit" do
      @version.whodunnit = nil
      @version.should_not be_valid
    end
    
    it "should not be valid without event type" do
      @version.event = nil
      @version.should_not be_valid
    end
  end

  describe "creates" do
    it "should only return creates" do
      PaperTrail::Model::DataMapper::Version.creates.each do |version| 
        version.event.should eql "create"
      end
    end
  end
  
  describe "updates" do
    it "should only return updates" do
      PaperTrail::Model::DataMapper::Version.updates.each do |version| 
        version.event.should eql "update"
      end
    end
  end
  
  describe "destroys" do
    it "should only return destroys" do
      PaperTrail::Model::DataMapper::Version.destroys.each do |version| 
        version.event.should eql "destroy"
      end
    end
  end
end

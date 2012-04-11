require 'spec_helper'

describe "PaperTrail" do
  before :each do
    PaperTrail.whodunnit = 1
  end

  context "Model Version" do
    it "should have a one version after create" do
      p = Post.create(:title => "Something", :content => "Something else")
      p.versions.count.should eql 1
    end

    it "should have two versions after first update" do
      p = Post.create(:title => "Something", :content => "Something else")
      p.versions.count.should eql 1
      p.title = "Something else"
      p.save
      p.versions.count.should eql 2
    end

    it "should increment the versions after every update" do
      p = Post.last
      prev_count = p.versions.count
      p.update(:title => "Somehting else")
      p.versions.count.should eql (1 + prev_count)
    end

    it "should create a version after destroy" do 
      p = Post.create(:title => "Something", :content => "Something else")
      p.versions.count.should eql 1
      post_id = p.id
      p.destroy
      versions = Post.version_class_name.constantize.with_item_keys(Post.name, post_id)
      versions.last.event.should eql "destroy"
    end
  end
end

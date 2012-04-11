require 'spec_helper'

describe "HasPaperTrailModel" do
  before :each do
    PaperTrail.whodunnit = 1
    @post = Post.create(:title => "Something", :content => "Something else")
  end

  context "new" do
    before :each do
      @new_post = Post.new(:title => "Title", :content => "Content")
    end

    it "should not have any versions" do
      @new_post.versions.should be_empty
    end
  
    it "should be live" do
      @new_post.live?.should be_true
    end

    # this is a change from activerecord as datamapper saves the record 
    # if you issue destory on a new record
    it "should create a version on destroy" do
      @new_post.destroy
      @new_post.versions.should_not be_empty
    end

    context "save" do
      before :each do
        @new_post.save
      end

      it "should have one version" do
        @new_post.versions.count.should eql 1
      end

      it "should be nil in first version" do
        @new_post.versions.first.object.should be_nil
        @new_post.versions.first.reify.should be_nil
      end

      it "should have proper event type" do
        @new_post.versions.first.event.should eql "create"
      end

      it "should be live" do
        @new_post.live?.should be_true
      end
      
      it "should not have changes" do
        @new_post.versions.last.changeset.should eql Hash.new
      end

      context "update with no changes" do
        it "should not create new version" do
          @new_post.save
          @new_post.versions.count.should eql 1
        end
      end

      context "update with changes" do
        before :each do
          @new_post.update(:title => "Changed Title")
        end

        it "should have two versions" do
          @new_post.versions.count.should eql 2
        end

        it "should have the changes in previous version" do
          @new_post.versions.last.object.should_not be_nil
          post = @new_post.versions.last.reify
          post.title.should eql "Title"
          @new_post.title.should eql "Changed Title"
        end
      end
    end
  end

  context "update" do
    it "should increment the version count" do
      @post.title = "Something 2"
      previous_count = @post.versions.count
      @post.save
      @post.versions.count.should eql (previous_count + 1);
    end
  end
end

require 'spec_helper'

describe "Article" do
  before :each do
    PaperTrail.whodunnit = 1
    @article = Article.new(:title => "Something", :content => "Something else", :abstract => "asdasdasdasD", :file_upload => "download.cybersecure.com.au/some.pdf" )
  end

  context "when new" do
    it "should not have any version" do
      @article.versions.should be_empty
    end

    context "is saved" do
      before :each do
        @article.save
      end

      it "should have one one version" do
        puts @article.versions.first.inspect
        @article.versions.should_not be_empty
      end
    
      context "and then updated" do
        it "should contain meta in the version" do
        end
      end
    end
  end
end

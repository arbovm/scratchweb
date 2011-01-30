require File.dirname(__FILE__) + '/../../../lib/scratchweb'

describe Scratchweb::Progress do
  
  describe "of a request with a content length of 200 bytes" do
    
    before :each do
      @progress = Scratchweb::Progress.new :content_length => 200
    end

    it "should initially have a progress of zero" do
      @progress.current.should be_eql(0)
    end

    it "should have a progress of 50% after reading 100 bytes" do
      @progress.add(100)
      @progress.current.should be_eql(50)
    end
    
    it "should have a progress of 100% after reading 200 bytes" do
      @progress.add(200)
      @progress.current.should be_eql(100)
    end
    
    it "should have a progress of 20% after reading four times 10 bytes" do
      4.times { @progress.add(10) }
      @progress.current.should be_eql(20)
    end
    
    it "should know when the progress is not finished yet " do
      @progress.add(199)
      @progress.is_finished.should be_eql(false)
    end
    
    it "should know when the progress is finished" do
      @progress.add(200)
      @progress.is_finished.should be_eql(true)
    end
    
    it "should yield the remaining bytes count" do
      @progress.add(101)
      @progress.remaining_bytes_count.should be_eql(99)
    end
  end
end
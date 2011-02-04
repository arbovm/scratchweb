require File.dirname(__FILE__) + '/../../../../lib/scratchweb'
require File.dirname(__FILE__) + '/fake_http_header'


describe Scratchweb::Parser::PostParser do
  
  POST_BODY = "title=aaa&key=value"
  
  before(:each) do
    header = FakeHttpHeader.new
    header.content_length = POST_BODY.bytesize
    @parser = Scratchweb::Parser::PostParser.new :http_header => header
  end
  
  it "should parse body" do    
    params = @parser.parse POST_BODY
    params[:title].should eql("aaa")
    params[:key].should eql("value")
  end
end
require File.dirname(__FILE__) + '/../../../../lib/scratchweb'



describe Scratchweb::Parser::PostParser do
  
  POST_BODY = "title=aaa&key=value"
  
  class FakeHttpHeader
    def content_length
      POST_BODY.size
    end
  end
  
  it "should parse body" do
    parser = Scratchweb::Parser::PostParser.new :socket => nil, :http_header => FakeHttpHeader.new
    params = parser.parse POST_BODY
    params[:title].should eql("aaa")
    params[:key].should eql("value")
  end
end
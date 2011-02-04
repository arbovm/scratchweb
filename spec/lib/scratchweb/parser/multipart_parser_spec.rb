require File.dirname(__FILE__) + '/../../../../lib/scratchweb'
require File.dirname(__FILE__) + '/fake_http_header'
require "stringio"


describe Scratchweb::Parser::MultipartParser do
  
  MULTIPART_POST_BODY = <<EOB
-----------------------------1954002605896735576441594\r
Content-Disposition: form-data; name="file"; filename="not_a.jpg"\r
Content-Type: image/jpeg\r
\r
start_of_filexxxxxxxxxxxxxxxxxxxx\r
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r
xxxxxxxxxxxxxxxxxxxxxxend_of_file\r
-----------------------------1954002605896735576441594\r
Content-Disposition: form-data; name="submit"\r
\r
Upload\r
-----------------------------1954002605896735576441594--\r
%\r
\r
\r
EOB

  before(:each) do
    header = FakeHttpHeader.new
    header.multipart_boundary = '---------------------------1954002605896735576441594'
    header.content_length = MULTIPART_POST_BODY.bytesize
    @parser = Scratchweb::Parser::MultipartParser.new :input => StringIO.new(MULTIPART_POST_BODY), :http_header => header 
  end
  
  it "should parse body" do
    file = @parser.receive{ true }
    content = IO.binread(file)
    content.should match(/^start_of_file.*/)
    content.split('\n')[-1].should match(/.*end_of_file/)
  end
  
  it "progress be 0 % before parsing" do
    @parser.receive do |progress|
      progress.current.should eql(0)
    end
  end
  
  it "progress be 100 % after parsing" do
    progress = nil
    @parser.receive do |p|
      progress = p
    end
    progress.current.should eql(100)
  end
end
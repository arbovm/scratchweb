require File.dirname(__FILE__) + '/../../lib/http_header.rb'

describe HttpHeader do
  
  HEADER_STRING = <<EOH
POST / HTTP/1.1
User-Agent: curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.19.7 OpenSSL/0.9.8l zlib/1.2.3
Host: localhost:8081
Accept: */*
Content-Length: 3273
Expect: 100-continue
Content-Type: multipart/form-data; boundary=----------------------------ac7579a3cd1d
EOH

  before(:each) do
    @handler = HttpHeader.new :header_string => HEADER_STRING
  end

  it "should parse the content length" do
  
    @handler.content_length.should eql(3273)

  end

end
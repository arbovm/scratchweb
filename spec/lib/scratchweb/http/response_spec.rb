require File.dirname(__FILE__) + '/../../../../lib/scratchweb'

describe Scratchweb::Http::Response do

  it "should build response with status code 200 by default" do
    header = Scratchweb::Http::Response.new :content => "ok"
    header.to_s.should eql("HTTP/1.1 200 OK\r\nServer: Scratchweb 0.1\r\nContent-Length: 2\r\nCache-Control: no-cache\r\nConnection: close\r\n\r\nok")
  end
  
  it "should set the content type" do
    header = Scratchweb::Http::Response.new :content => "ok", :content_type => "text/plain"
    header.to_s.should include("Content-Type: text/plain\r\n")
  end

  it "should handle status code 404" do
    header = Scratchweb::Http::Response.new :status_code => :'404' 
    header.to_s.should eql("HTTP/1.1 404 Not Found\r\nServer: Scratchweb 0.1\r\nCache-Control: no-cache\r\nConnection: close\r\n\r\n")
  end

  it "should build redirect" do
    header = Scratchweb::Http::Response.new :status_code => :'302', :location => "/welcome_back.html" 
    header.to_s.should eql("HTTP/1.1 302 Found\r\nServer: Scratchweb 0.1\r\nLocation: /welcome_back.html\r\nCache-Control: no-cache\r\nConnection: close\r\n\r\n")
  end
  
  it "should yield just the header without body when setting content length" do
    header = Scratchweb::Http::Response.new  :content_length => 4242 
    header.to_s.should eql("HTTP/1.1 200 OK\r\nServer: Scratchweb 0.1\r\nContent-Length: 4242\r\nCache-Control: no-cache\r\nConnection: close\r\n\r\n")
  end
end
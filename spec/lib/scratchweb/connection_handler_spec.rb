require File.dirname(__FILE__) + '/../../../lib/scratchweb'

describe Scratchweb::ConnectionHandler do
  
MULTIPART_HTTP_REQUEST = <<EOB
POST /uploads HTTP/1.1
User-Agent: curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.19.7 OpenSSL/0.9.8l zlib/1.2.3
Host: localhost:8081
Accept: */*
Content-Length: 3273
Expect: 100-continue
Content-Type: multipart/form-data; boundary=-----------------------------1954002605896735576441594

-----------------------------1954002605896735576441594
Content-Disposition: form-data; name="file"; filename="not_an.jpg"
Content-Type: image/jpeg

start_of_filexxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
-----------------------------1954002605896735576441594
Content-Disposition: form-data; name="submit"

Upload
-----------------------------1954002605896735576441594--
%


EOB
  
  # class FakeSocket
  #   def initialize
  #     @lines = MULTIPART_HTTP_REQUEST.split('\n')
  #     @line_index = -1;
  #   end
  #   
  #   def gets
  #     @line_index += 1
  #     @lines[@line_index]
  #   end
  #   
  #   def close
  #   end
  # end
  # 
  # 
  # before(:each) do
  #   fake_socket = FakeSocket.new
  #   @handler = Scratchweb::ConnectionHandler.new(:client_socket => fake_socket, :store => {})
  # end
  # 
  # it "should find the start of the first file" do
  #   @handler.fast_forward_to_file
  #   @handler.gets.should eql("start_of_filexxxxxxxxxxxxxxxxxxxx")
  # end
  

  

end
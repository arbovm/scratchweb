require File.dirname(__FILE__) + '/../../lib/scratchweb'

describe HttpHeader do
  
  POST_HEADER = <<EOH
POST /uploads HTTP/1.1
User-Agent: curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.19.7 OpenSSL/0.9.8l zlib/1.2.3
Host: localhost:8081
Accept: */*
Content-Length: 3273
Expect: 100-continue
Content-Type: multipart/form-data; boundary=----------------------------ac7579a3cd1d
EOH

  GET_HEADER = <<EOH
GET /uploads/123/progress HTTP/1.1
Host: 0.0.0.0:8081
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-us) AppleWebKit/533.19.4 (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4
Accept: application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: keep-alive  
EOH

  DELETE_HEADER = <<EOH
DELETE / HTTP/1.1
User-Agent: curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.19.7 OpenSSL/0.9.8l zlib/1.2.3
Host: 0.0.0.0:8081
Accept: */*
  
EOH

  describe "when processing POST header with path /uploads" do
    
    before(:each) do
      @handler = HttpHeader.new :header_string => POST_HEADER
    end
    
    it "should parse content length" do  
      @handler.content_length.should eql(3273)
    end
    
    it "should know its method" do
      @handler.method.should be(:post)
      @handler.method?(:post).should be_true
      @handler.method?(:get ).should be_false
    end
    
    it "should know its path" do
      @handler.path.should be_eql("/uploads")
    end
    
    it "should know its route per method" do
      @handler.route?(:post, "/uploads"){true}.should be_true
      @handler.route?(:post, "/"){true}.should be_false
      @handler.route?(:get,  "/uploads"){true}.should be_false
      @handler.route?(:post, "/xxxxxxx"){true}.should be_false
    end
    
    it "route should understand params in path" do
      @handler.route?(:post, "/:path"){|path| path.should eql("uploads")}
      @handler.route?(:get,  "/:path"){true}.should be_false
      @handler.route?(:post, "/uploads/:path"){true}.should be_false
    end
    
    it "should extract path params" do
      @handler.extract_path_params("/:path").should be_eql(["uploads"])
    end
    
  end
  
  describe "when processing GET header with path /uploads/123/progress" do
    
    before(:each) do
      @handler = HttpHeader.new :header_string => GET_HEADER
    end
    
    it "content length should be zero for GET header without content-length" do  
      @handler.content_length.should eql(0)
    end 
    
    it "should know its method" do
      @handler.method.should be(:get)
      @handler.method?(:get ).should be_true
      @handler.method?(:post).should be_false
    end
       
    it "should know its path" do
      @handler.path.should be_eql("/uploads/123/progress")
    end
    
    it "should extract path params" do
      @handler.extract_path_params("/uploads/:id/progress").should be_eql(["123"])
    end
    
  end
  
  describe "when processing DELETE header" do
    
    before(:each) do
      @handler = HttpHeader.new :header_string => DELETE_HEADER
    end

    it "should know its method" do
      @handler.method.should be(:delete)
    end
  end
end
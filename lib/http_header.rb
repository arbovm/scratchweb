class HttpHeader
  
  attr_accessor :content_length
  
  def initialize attributes
    @header_string = attributes[:header_string]
    
    @content_length = parse(/Content-Length: ([0-9]+)/).to_i


  end
  
  def parse regexp_with_group
    if match = @header_string.scan(regexp_with_group)
       match[0][0]
    end
  end
  
end
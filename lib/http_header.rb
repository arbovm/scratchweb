class HttpHeader
  
  attr_accessor :content_length, :method, :path
  
  def initialize attributes
    @header_string = attributes[:header_string]
    
    @path = parse(/\w+ ([^ ]+) HTTP\/1.[0-1]/)
    @method = parse(/(\w+) [^ ]+ HTTP\/1.[0-1]/).downcase.to_sym
    @content_length = parse(/Content-Length: ([0-9]+)/).to_i
  end
  
  def parse regexp_with_group
    if (match = @header_string.scan(regexp_with_group)) && match[0]
       match[0][0]
    end
  end
  
  def method? type
    @method == type
  end
  
  def route? method, path
    method?(method) && @path == path
  end
end
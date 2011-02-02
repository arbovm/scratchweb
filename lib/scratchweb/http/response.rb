module Scratchweb
  module Http
    class Response
      def initialize attrs
        @content_type   = attrs[:content_type]
        @content        = attrs[:content]
        @content_length = attrs[:content_length]
        @status_code    = attrs[:status_code]
        @location       = attrs[:location]
      end
      
      def to_s
        str  =  if @status_code == :'404'
          "HTTP/1.1 404 Not Found\r\n"
        elsif @status_code == :'302'
          "HTTP/1.1 302 Found\r\n"
        else
          "HTTP/1.1 200 OK\r\n"
        end
        str += "Server: Scratchweb 0.1\r\n"
        str += "Location: #{@location}\r\n" if @location
        str += "Content-Type: #{@content_type}\r\n" if @content_type
        if @content
          str += "Content-Length: #{@content.size}\r\n"
        elsif @content_length
          str += "Content-Length: #{@content_length}\r\n"
        end
        str += "Cache-Control: no-cache\r\n"
        str += "Connection: close\r\n\r\n"
        str += "#{@content}" if @content
        str
      end
    end
  end
end
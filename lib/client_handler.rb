
class ClientHandler
  
  CHUNK_SIZE = 1024
  END_OF_HEADER = "\r\n"
  
  def initialize client_socket
    @socket = client_socket
  end
  
  def handle
    begin
      @http_header = HttpHeader.new :header_string => read_header
      route
    ensure
      @socket.close
    end
  end
  
  def read_header
    header  = ""
    while (line = @socket.gets) && line != END_OF_HEADER
      header += line
    end
    puts "\n>>> header:\n#{header}\n<<<"
    header
  end
  
  def route
    if @http_header.route?(:get,"/")
      render :text => "server root"
      
    elsif @http_header.route?(:get,"/uploads")
      render :text => "uploads"
      
    elsif @http_header.route?(:post,"/uploads")
     receive
     redirect :to => "/"

    end
  end
  
  def receive

    progress = Progress.new :content_length => @http_header.content_length
    until progress.is_finished
      bytes_to_read = [CHUNK_SIZE, progress.byte_count_remaining].min
      chunk  = @socket.read(bytes_to_read)        
      progress.add(chunk.size)
      puts "#{progress.current}%"
    end
    puts "finished"

  end
  
  def redirect attrs
    @socket.write("HTTP/1.1 302 Found\r\nLocation: #{attrs[:to]}\r\n\r\n")
  end
  
  def render attrs
    text = attrs[:text]
    @socket.write("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{text.size}\r\n\r\n#{text}")
  end
end
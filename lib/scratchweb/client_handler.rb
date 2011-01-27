
class ClientHandler
  
  CHUNK_SIZE = 1024
  END_OF_HEADER = "\r\n"
  APP_DIR = File.dirname(__FILE__) + "/../../app"
  
  def initialize attrs
    @socket = attrs[:client_socket]
    @store  = attrs[:store]
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
      render :view => :index
      
    elsif @http_header.route?(:get,"/uploads")
      render :text => "uploads"
      
    elsif @http_header.route?(:get,"/uploads/progress")
      progress = @store[123]
      if progress
        render :text => progress.current.to_s
      else
        render :text => "unknown"
      end
    elsif @http_header.route?(:post,"/uploads")
     receive
     redirect :to => "/"
     
    elsif @http_header.route?(:get,"/assets/.*")
      puts "rendering static asset #{@http_header.path}"
      render :asset => @http_header.path
      
    else
      render_error :not_found
   end
  end
  
  def receive

    progress = Progress.new :content_length => @http_header.content_length
    @store[123] = progress
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
  
  
  def render_error kind
    response = nil
    if kind == :not_found 
      content  = IO.binread(APP_DIR+"/views/404.html")
      response = "HTTP/1.1 404 NOT_FOUND\r\nContent-Type: text/html\r\nContent-Length: #{content.size}\r\n\r\n#{content}"
      
    else
      raise "\n!!! Don't know which error to render kind:#{kind.inspect}\n"
    end

    @socket.write(response)
  end
  
  def render attrs

    response = nil    
    if text = attrs[:text]
      response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{text.size}\r\n\r\n#{text}"
      
    elsif asset = attrs[:asset]
      content  = IO.binread(APP_DIR+asset) #TODO Fix security issue
      response = "HTTP/1.1 200 OK\r\nContent-Length: #{content.size}\r\n\r\n#{content}"
    
    elsif view = attrs[:view]
      content  = IO.binread(APP_DIR+"/views/#{view}.html")
      response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content.size}\r\n\r\n#{content}"
      
    elsif attrs[:not_found]
      content  = IO.binread(APP_DIR+"/views/404.html")
      response = "HTTP/1.1 404 NOT_FOUND\r\nContent-Type: text/html\r\nContent-Length: #{content.size}\r\n\r\n#{content}"
      
    else
      raise "\n!!! Don't know what to render attrs:#{attrs.inspect}\n"
    end

    @socket.write(response)
  end
end
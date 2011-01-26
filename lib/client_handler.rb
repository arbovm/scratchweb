
class ClientHandler
  
  UPLOAD_CHUNK_SIZE = 64*1024
  END_OF_HEADER = "\r\n"
  
  def initialize clientSocket
    @socket = clientSocket
  end
  
  def handle
    @http_header = HttpHeader.new :header_string => read_header
    receive
  end
  
  def read_header
    header  = ""
    while (line = @socket.gets) && line != END_OF_HEADER
      header += line
    end
    puts "\n>>> header:\n#{header}\n<<<"
    header
  end
  
  def receive
    progress = Progress.new :content_length => @http_header.content_length
    until progress.is_finished
      chunk, socket_addr  = @socket.recvfrom(UPLOAD_CHUNK_SIZE)
      progress.add(chunk.size)
      puts "#{progress.current}%"
    end
    puts "finished"
  end
  
end
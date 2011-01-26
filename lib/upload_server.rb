
class UploadServer
  
  def initialize attrs
    @host   = attrs[:host]
    @port   = attrs[:port]
    @routes = attrs[:routes]
  end
  
  def start
    serverSocket = TCPServer.open(@host, @port)
    puts "please open http://#{@host}:#{@port}"
    
    loop do
      clientSocket = serverSocket.accept

      # Thread.start do
        ClientHandler.new(clientSocket).handle
      # end
    end
  end
  
end


require 'socket'

class ScratchServer
  
  def initialize attrs
    @host   = attrs[:host]
    @port   = attrs[:port]
    @routes = attrs[:routes]
    @store  = {}
  end
  
  def start
    server_socket = TCPServer.open(@host, @port)
    puts "please open http://#{@host}:#{@port}"
    
    loop do
      Thread.start(server_socket.accept) do |client_socket|
        ClientHandler.new(:client_socket => client_socket, :store => @store).handle
      end
    end
  end
  
end


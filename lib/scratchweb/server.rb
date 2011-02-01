require 'socket'

module Scratchweb
  class Server
  
    def initialize attrs
      @connection_handler = attrs[:connection_handler]
      @host   = attrs[:host]
      @port   = attrs[:port]
    end
  
    def start
      server_socket = TCPServer.open(@host, @port)
      puts "please open http://#{@host}:#{@port}"
    
      loop do
#        client_socket = server_socket.accept
        Thread.start(server_socket.accept) do |client_socket|
          @connection_handler.new(:client_socket => client_socket).handle
        end
      end
    end
  end
end


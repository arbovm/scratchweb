require 'socket'

module Scratchweb
  class Server
  
    def initialize attrs
      @client_handler = attrs[:client_handler]
      @host   = attrs[:host]
      @port   = attrs[:port]
      @routes = attrs[:routes]
      @store  = {}
    end
  
    def start
      server_socket = TCPServer.open(@host, @port)
      puts "please open http://#{@host}:#{@port}"
    
      loop do
#        client_socket = server_socket.accept
        Thread.start(server_socket.accept) do |client_socket|
          @client_handler.new(:client_socket => client_socket, :store => @store).handle
        end
      end
    end
  end
end


require 'tempfile'


module Scratchweb
  class ConnectionHandler
  
    END_OF_HEADER = "\r\n"
    APP_DIR = File.dirname(__FILE__) + "/../../app"
  
    def initialize attrs
      @socket = attrs[:client_socket]
      @responded = false
    end
  
    def handle
      begin
        @http_header = Http::Header.new :header_string => read_header
        log "request: #{@http_header.method} #{@http_header.path}"
        dispatch
        render :error => :not_found unless @responded
      ensure
        @socket.close
      end
    end
  
    def read_header
      header  = ""
      while (line = @socket.gets) && (line != END_OF_HEADER)
        header += line
      end
      log "header:\n#{header}\nend_header"
      header
    end
  
    def dispatch
      raise NotImplementedError.new("Please implement dispatch.")
    end

    def action method, path, &blk
      @http_header.call_if_action_matches(method, path, &blk)
    end
    
    def redirect attrs
      respond_with Http::Response.new(:status_code => :'302', :location => attrs[:to])
    end
  
    def render attrs
      response = nil    
      if text = attrs[:text]
        response = Http::Response.new(:content_type => 'text/plain', :content => text)
      
      elsif asset = attrs[:asset]
        content  = IO.binread(APP_DIR+"/assets/"+asset) #TODO Fix security flaw
        response = Http::Response.new(:content => content)
    
      elsif view = attrs[:view]
        content  = IO.binread(APP_DIR+"/views/#{view}.html")
        response = Http::Response.new(:content_type => 'text/html', :content => content)
      
      elsif attrs[:error] == :not_found
        content  = IO.binread(APP_DIR+"/views/404.html")
        response = Http::Response.new(:status_code => :'404', :content_type => 'text/html', :content => content)
      
      else
        raise "\n!!! Don't know what to render attrs:#{attrs.inspect}\n"
      end

      if response
        respond_with response
      else
        render_error :not_found
      end
    end

    def respond_with response
      @responded = true
      @socket.write(response.to_s)
    end
    
    def multipart_parser
      Scratchweb::MultipartParser.new :http_header => @http_header, :input => @socket
    end
      
    def log str
      puts "\n--#{self.object_id}\n#{str}\n--#{self.object_id}"
    end
    
  end
end

module Scratchweb
  module Parser
    module Base

        def initialize attrs
          @http_header  = attrs[:http_header]
          @socket       = attrs[:input]
          @progress = Progress.new :content_length => @http_header.content_length
        end

        def read_line
          line = @socket.gets
          @progress.add(line.bytesize)
          line
        end

        def read_remaining_bytes_of_body
          chunk = @socket.read(@progress.remaining_bytes_count)
          @progress.add(chunk.size)
          chunk
        end

    end
  end
end
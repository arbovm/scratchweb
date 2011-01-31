module Scratchweb
  class MultipartParser
    
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
    
    def fast_forward_to_next_part
      line = ""
      until is_multipart_boundary?(line) || @progress.is_finished
        line = read_line
      end
    end

    def fast_forward_to_file
      line = ""
      unless is_multipart_file_content_header?(line) || @progress.is_finished
        fast_forward_to_next_part
        line = read_line unless @progress.is_finished
      end
      skip_rest_of_multipart_header
    end  
    
    def skip_rest_of_multipart_header
      2.times do
        line = read_line unless @progress.is_finished
      end
    end
    
    def is_multipart_file_content_header? line
      line.match /Content-Disposition: form-data; name="[^"]+"; filename="^["]+"/
    end
    
    def receive &blk
      yield @progress
      fast_forward_to_file
      file = safe_to_tempfile
      read_rest_of_body
      file
    end
    
    def safe_to_tempfile
      end_found = false
      line = ""
      last_line = ""
      file = Tempfile.new("upload-")
      begin
        until end_found || @progress.is_finished
          line = read_line
          end_found = is_multipart_boundary? line
          if end_found
            last_line = skip_carriage_return_line_feed_at_end_of(last_line) 
          end
          file.write(last_line)
          last_line = line
        end
      ensure
        file.close
      end
      puts "upload finished. file saved to #{file.path}"
      file
    end

    def is_multipart_boundary? line
      line.start_with? "--"+@http_header.multipart_boundary
    end
    
    def skip_carriage_return_line_feed_at_end_of line
      line[0..-3]
    end
    
    def read_rest_of_body
      chunk = @socket.read(@progress.remaining_bytes_count)
      @progress.add(chunk.size)
    end
  end
end
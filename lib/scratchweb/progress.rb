module Scratchweb
  class Progress
  
    def initialize attributes
      @content_length = attributes[:content_length]
      @total_read_bytes = 0
    end
  
    def add read_bytes
      @total_read_bytes += read_bytes
    end
  
    def current
      (100.0 * @total_read_bytes.to_f / @content_length.to_f).round
    end
  
    def is_finished
       @total_read_bytes >= @content_length
    end
  
    def remaining_bytes_count
      @content_length - @total_read_bytes
    end
  end
end

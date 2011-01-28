module Scratchweb
  class Progress
  
    def initialize attributes
      @content_length = attributes[:content_length]
      @total_read_bytes = 0
      @current_progress = 0.0
    end
  
    def add read_bytes
      @total_read_bytes += read_bytes
      recompute_current_progress
    end
  
    def current
      @current_progress.round
    end
  
    def is_finished
       @total_read_bytes >= @content_length
    end
  
    def byte_count_remaining
      @content_length - @total_read_bytes
    end
  
    private
  
    def recompute_current_progress
      @current_progress = 100.0 * @total_read_bytes.to_f / @content_length.to_f
  #    puts "#{@total_read_bytes} / #{@content_length}"
    end
  end
end

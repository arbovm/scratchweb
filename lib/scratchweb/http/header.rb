module Scratchweb
  module Http
    class Header
  
      attr_accessor :content_length, :method, :path, :multipart_boundary
  
      def initialize attributes
        @header_string = attributes[:header_string]

        @method = parse(/(\w+) [^ ]+ HTTP\/1.[0-1]/).downcase.to_sym    
        @path = parse(/\w+ ([^ ]+) HTTP\/1.[0-1]/)
        @content_length = parse(/Content-Length: ([0-9]+)/).to_i
        @multipart_boundary = parse(/^Content-Type: multipart\/form-data; boundary=(.*)$/)
      end
  
      def parse regexp_with_group
        if (match = @header_string.scan(regexp_with_group)) && match[0]
           match[0][0]
        end
      end
  
      def method? type
        @method == type
      end
  
      def call_if_action_matches method, path, &blk
        quoted_slashes_and_replaced_params = path.gsub('/','\/').gsub(/:[^\/]*/, '[^/]+')
        path_regexp = /^#{quoted_slashes_and_replaced_params}$/
        if method?(method) && @path.match(path_regexp)
          params = extract_path_params(path)
          yield(*params)
        end
      end
  
      def extract_path_params path
        result = []
        splitted_and_zipped = path.split('/').zip(@path.split('/'))
        splitted_and_zipped.each do |part1,part2|
          if part1.match(/^:\w+$/)
            result << part2
          end
        end
        result
      end
    end
  end
end
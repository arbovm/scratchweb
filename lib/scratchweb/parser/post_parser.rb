module Scratchweb
  module Parser
    class PostParser
      
      include Base
      
      def params
        body = read_remaining_bytes_of_body
        parse body
      end
      
      def parse body
        result = {}
        body.split('&').each do |key_and_value|
          key,value = key_and_value.split('=')
          result[key.to_sym] = value
        end
        result
      end
    end
  end
end
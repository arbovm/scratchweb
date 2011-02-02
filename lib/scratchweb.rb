if RUBY_VERSION != '1.9.2'
  puts "scratchweb needs Ruby version 1.9.2 (current version:#{RUBY_VERSION})"
  exit
end

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'scratchweb/server'
require 'scratchweb/connection_handler'
require 'scratchweb/parser/base'
require 'scratchweb/parser/post_parser'
require 'scratchweb/parser/multipart_parser'
require 'scratchweb/http/header'
require 'scratchweb/http/response'
require 'scratchweb/progress'
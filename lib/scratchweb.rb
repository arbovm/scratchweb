libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'scratchweb/scratch_server'
require 'scratchweb/client_handler'
require 'scratchweb/http_header'
require 'scratchweb/progress'
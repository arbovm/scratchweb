libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'scratchweb/server'
require 'scratchweb/connection_handler'
require 'scratchweb/http/header'
require 'scratchweb/progress'
#!/usr/bin/env ruby

require 'socket'

require File.dirname(__FILE__) + '/lib/upload_server.rb'
require File.dirname(__FILE__) + '/lib/client_handler.rb'
require File.dirname(__FILE__) + '/lib/http_header.rb'
require File.dirname(__FILE__) + '/lib/progress.rb'



UploadServer.new(:host => "0.0.0.0", :port => "8081").start
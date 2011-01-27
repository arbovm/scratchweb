#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/lib/scratchweb'


ScratchServer.new(:host => "0.0.0.0", :port => "8081").start
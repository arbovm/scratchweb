#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/lib/scratchweb'

class Config
  def self.store
    @store ||= {}
    @store
  end
end

class App < Scratchweb::ConnectionHandler
  
  def dispatch
    
    # form
    action(:get,"/") do
      render :view => :index
    end

    # create upload
    action(:post,"/uploads.js") do
      id = rand(1000).to_s
      render :text => '{"_id":'+id+'}'
    end

    # create file upload
    action(:post,"/uploads/:id/file") do |id|
      
      file = multipart_parser.receive do |progress|
        Config.store[id] = progress
      end

      redirect :to => "/empty.html"
    end
    
    # target iframe content after upload
    action(:get,"/empty.html") do
      render :view => :empty
    end

    # show nested progress resource of upload
    action(:get,"/uploads/:id/progress") do |id|
      progress = Config.store[id]
      if progress
        render :text => progress.current.to_s
      else
        render :error => :not_found
      end
    end
    
    # show upload
    action(:get,"/uploads/:id") do |id|
      render :view => :show #id
    end
    
    # deliver assets
    action(:get,"/assets/:file_name") do |file_name|
      render :asset => file_name
    end
    
  end
  
end

Scratchweb::Server.new(:host => "0.0.0.0", :port => "8081", :client_handler => App).start
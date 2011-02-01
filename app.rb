#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/lib/scratchweb'
require File.dirname(__FILE__) + '/lib/transient_db'
require File.dirname(__FILE__) + '/app/models/upload'

class App < Scratchweb::ConnectionHandler
  
  def dispatch
    
    # form
    action(:get,"/") do
      render :view => :index
    end

    # create upload
    action(:post,"/uploads.js") do
      upload = Upload.create()
      render :text => '{"_id":"'+upload.id+'"}'
    end

    # create file upload
    action(:post,"/uploads/:id/file") do |id|
      upload = Upload.find(id)
      file = multipart_parser.receive do |progress|
        upload.progress = progress
      end

      upload.file = file
      
      redirect :to => "/empty.html"
    end
    
    # target iframe content after upload
    action(:get,"/empty.html") do
      render :view => :empty
    end

    # show nested progress resource of upload
    action(:get,"/uploads/:id/progress") do |id|
      upload = Upload.find(id)
      if upload
        render :text => upload.progress.current.to_s
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

Scratchweb::Server.new(:host => "0.0.0.0", :port => "8081", :connection_handler => App).start
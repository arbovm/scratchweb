#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/lib/scratchweb'
require File.dirname(__FILE__) + '/lib/transient_db'
require File.dirname(__FILE__) + '/app/models/upload'

class App < Scratchweb::ConnectionHandler
  
  def dispatch
    
    # render form
    action(:get,"/") do
      render :view => :index
    end

    # create upload
    action(:post,"/uploads.js") do
      upload = Upload.create
      log upload.to_json
      render :text => upload.to_json
    end

    # create file upload
    action(:post,"/uploads/:id/file") do |id|
      upload = Upload.find(id)
      file = multipart_parser.receive do |progress|
        upload.progress = progress
      end
      upload.file = file
      log "upload finished. file saved to #{file.path}"
      render :text => "done"
    end
    
    # download file
    action(:get,"/uploads/:id/file/:title") do |id|
      upload = Upload.find(id)
      if upload
        serve_download :file_path => upload.file
      else
        render :error => :not_found
      end
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

    # save title of uploaded file
    action(:post,"/uploads/:id/title") do |id|
      upload = Upload.find(id)
      upload.title = post_parser.params[:title]
      if upload
        render :text => upload.to_json
      else
        render :error => :not_found
      end
    end
    
    # show upload
    action(:get,"/uploads/:id") do |id|
      upload = Upload.find(id)
      if upload
        render :text => upload.to_json
      else
        render :error => :not_found
      end
    end
    
    # deliver assets
    action(:get,"/assets/:file_name") do |file_name|
      render :asset => file_name
    end
    
  end
  
end

Scratchweb::Server.new(:host => "0.0.0.0", :port => "8081", :connection_handler => App).start
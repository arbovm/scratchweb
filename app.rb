#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/lib/scratchweb'

class App < Scratchweb::ConnectionHandler
  
  def dispatch
    
    # welcome
    action(:get,"/") do
      render :view => :index
    end

    # create upload
    action(:post,"/uploads.js") do
      id = rand(1000).to_s
      render :text => '{"_id":'+id+'}'
    end

    # update upload
    action(:post,"/uploads/:id") do |id|
      receive(id)
      redirect :to => "/done.html"
    end

    action(:get,"/done.html") do
      render :view => :done
    end

    # show nested progress resource of upload
    action(:get,"/uploads/:id/progress") do |id|
      progress = @store[id]
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
    
    action(:get,"/assets/:file_name") do |file_name|
      render :asset => file_name
    end
    
  end
  
end

Scratchweb::Server.new(:host => "0.0.0.0", :port => "8081", :client_handler => App).start
require 'sinatra'
require 'sprockets'
class Assets < Sinatra::Base
  set :sprockets, Sprockets::Environment.new(root)

  configure do
    sprockets.append_path("assets/javascripts")
    sprockets.append_path("assets/stylesheets")
  end

  get '/stylesheets/styles.css' do
    content_type "text/css"
    settings.sprockets['styles.css']
  end

  get '/javascripts/app.js' do
    content_type "application/javascript"
    settings.sprockets['app.js']
  end
end

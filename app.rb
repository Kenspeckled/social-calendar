require 'sinatra'
require './assets'
require 'slim'

class SocialCalendarApp < Sinatra::Base
  use Assets

  get '/' do
    slim :index
  end

  post '/messages/new' do
    # Do something with params
    redirect to '/'
  end

end

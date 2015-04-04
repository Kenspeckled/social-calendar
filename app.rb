require 'sinatra'
require './assets'
require 'slim'

class SocialCalendarApp < Sinatra::Base
  use Assets

  get '/' do
    slim :index
  end

end

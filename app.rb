require 'sinatra/base'

class URLShortenerAdmin < Sinatra::Base
  get '/admin' do
    slim :show, layout: :'layouts/index'
  end

  get '/admin/create' do
    slim :create, layout: :'layouts/index'
  end
end

class URLShortener < Sinatra::Base
  require './url_store.rb'
  use URLShortenerAdmin

  not_found do 
    "not found"
  end

  get /(\w+)/ do
    shortened_url = params['captures']
    full_url = URLStore.find(shortened_url)
    if full_url
      Analytics.add_to_counter(shortened_url)
      redirect full_url
    else
      halt 404 
    end
  end
end

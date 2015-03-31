require 'sinatra/base'


class URLShortenerAdmin < Sinatra::Base
  require './url_store.rb'
  before do
    #is_authenticated = BCrypt::Engine.hash_secret(password, salt)...
    is_authenticated = true
    if !is_authenticated
      error 401
    end
  end

  error 401 do
    "unauthorized"
  end

  get '/admin' do
    @urls = URLStore.get_all
    slim :show, layout: :'layouts/index'
  end

  get '/admin/create' do
    slim :create, layout: :'layouts/index'
  end

  post '/admin/url/new' do
    key = params['key']
    url = params['url']
    if url and url != ''
      if key and key == ''
        key = rand(36**5).to_s(36)
      end
      URLStore.set(key, url)
    end
    redirect '/admin'
  end
end

class URLShortener < Sinatra::Base
  require './url_store.rb'
  require './analytics.rb'
  use URLShortenerAdmin

  not_found do
    "not found"
  end

  get /(\w+)/ do
    shortened_url = params['captures'].first
    full_url = URLStore.find(shortened_url)
    if full_url
      Analytics.add_to_counter(shortened_url)
      redirect full_url
    else
      halt 404
    end
  end
end

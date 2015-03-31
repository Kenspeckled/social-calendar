require 'sinatra/base'


class URLShortenerAdmin < Sinatra::Base
  register do
    def check(name)
      condition do
        error 401 unless send(name) == true
      end
    end
  end

  helpers do
    def authenticated?
      #BCrypt::Engine.hash_secret(password, salt)...
      true
    end
  end

  error 401 do
    "unauthorized"
  end

  get '/admin', check: :authenticated? do
    slim :show, layout: :'layouts/index'
  end

  get '/admin/create', check: :authenticated? do
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

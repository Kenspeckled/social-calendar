require 'sinatra/base'

class LogIn < Sinatra::Base
  require './admin.rb'

  error 401 do
    slim :'errors/401', layout: :'layouts/index'
  end

  get '/admin/log-in' do
    slim :log_in, layout: :'layouts/index'
  end

  post '/admin/log-in' do
    user = Admin.authenticate(params[:email], params[:password])
    if user
      session[:user_email] = user["email"]
      redirect '/admin'
    else
      error 401
    end
  end
end


class URLShortenerAdmin < Sinatra::Base
  require './url_store.rb'
  require 'yaml'
  config = YAML.load_file('config.yml')

  use LogIn

  error 400 do
    slim :'errors/400', layout: :'layouts/index'
  end

  before do
    if !session[:user_email]
      error 401
    end
  end

  get '/admin' do
    @base_url = config['base_url'] || request.url.sub(request.path, "").sub("?#{request.query_string}", "")
    @readable_base_url = @base_url.to_s.sub("http://","").sub("https://","")
    @urls = URLStore.get_all
    if params['sort'] == 'name'
      @urls.sort_by!{|v| v['name'].to_s.downcase }
    elsif params['sort'] == 'date'
      @urls.sort_by!{|v| v['created_at'].to_i }
    elsif params['sort'] == 'visits'
      @urls.sort_by!{|v| v['counter'].to_i }
    end
    if params['sort_order'] == 'desc'
      @urls.reverse!
      @next_sort_order = 'asc'
    else
      @next_sort_order = 'desc'
    end
    slim :show, layout: :'layouts/index'
  end


  get '/admin/create' do
    slim :create, layout: :'layouts/index'
  end

  post '/admin/url/new' do
    name = params['name']
    key = params['key']
    url = params['url']
    if name and name != '' and url and url != ''
      if key and key == ''
        key = rand(36**5).to_s(36)
      end
      URLStore.set({name: name, key: key, url: url})
      redirect '/admin'
    else
      halt 400
    end
  end
end

class URLShortener < Sinatra::Base
  require './url_store.rb'
  require './analytics.rb'
  require 'yaml'

  config = YAML.load_file('config.yml')

  enable :sessions
  set :session_secret, config['session_secret']

  not_found do
    "not found"
  end

  use URLShortenerAdmin

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

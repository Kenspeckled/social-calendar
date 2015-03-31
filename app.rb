require 'sinatra'
require './url_store.rb'

not_found do 
  "not found"
end

get /(\w+)/ do
  shortened_url = params['captures']
  full_url = URLStore.find(shortened_url)
  if full_url
    redirect full_url
  else
    halt 404 
  end
end


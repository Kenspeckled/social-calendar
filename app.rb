require 'sinatra'

not_found do 
  "not found"
end

get /(\w+)/ do
  shortened_url = params['captures']
  # full_url = Database.find_by(shortened_url)
  full_url = "http://www.discoverscotland.co.uk"
  if full_url
    redirect full_url
  else
    halt 404 
  end
end


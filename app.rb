require 'sinatra'
require './assets'
require './lib/data_store'
require 'slim'
require 'json'

class SocialCalendarApp < Sinatra::Base
  use Assets

  get '/' do
    slim :index
  end

  post '/messages/new' do
    message = {}
    time = params[:date].to_i
    if params[:time] and !params[:time].empty?
      hours, minutes = params[:time].split(":").map{|str| str.to_i}  
      seconds = hours * 60 * 60 + minutes * 60
      time += seconds
    end
    message[:time] = time 
    message[:message] = params[:message]
    message[:service] = params[:service]
    puts "Creating Message", message
    DataStore.create(message)
    redirect to '/'
  end

  get '/messages/date/:date' do |date|
    dateArray = date.split('-')
    year = dateArray[0]
    month = dateArray[1]
    day = dateArray[2]
    messages = DataStore.where_date(year, month, day)
    response = {messages: messages}
    return response.to_json 
  end

  get '/messages/:id' do |id|
    DataStore.find(id)
  end

  post '/messages/:id/edit' do |id|
    message = {}
    time = params[:date].to_i
    if params[:time] and !params[:time].empty?
      hours, minutes = params[:time].split(":").map{|str| str.to_i}  
      seconds = hours * 60 * 60 + minutes * 60
      time += seconds
    end
    message[:time] = time 
    message[:message] = params[:message]
    message[:service] = params[:service]
    puts "Updating Message", message
    DataStore.update(id, message)
    redirect to '/'
  end

end

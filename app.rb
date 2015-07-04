require 'sinatra'
require_relative './assets'
require_relative './lib/data_store'
require_relative './lib/scheduler'
require 'slim'
require 'sass'
require 'coffee_script'
require 'json'
require 'cgi'

class SocialCalendarApp < Sinatra::Base
  #use Assets  # using precompiled assets instead

  scheduler = fork do 
    puts "\nStarting scheduler\n"
    Scheduler.start_polling
  end
  Process.detach(scheduler)

  before do
    @version = File.read(File.join(settings.root, 'public/assets/version'))
  end

  get '/calendar' do
    if !session[:user_email]
      error 401
    end
    slim :index
  end

  post '/messages/new' do
    if !session[:user_email]
      error 401
    end
    message = {}
    time = params[:date].to_i
    if params[:time] and !params[:time].empty?
      hours, minutes = params[:time].split(":").map{|str| str.to_i}  
      seconds = hours * 60 * 60 + minutes * 60
      time += seconds
    end
    message[:time] = time 
    message[:message] = CGI::escapeHTML(params[:message]).force_encoding(Encoding::UTF_8)
    message[:service] = params[:service]
    DataStore.create(message)
    redirect to '/calendar'
  end

  get '/messages/date/:date' do |date|
    if !session[:user_email]
      error 401
    end
    dateArray = date.split('-')
    year = dateArray[0]
    month = dateArray[1]
    day = dateArray[2]
    messages = DataStore.where_date(year, month, day)
    messages = CGI::escapeHTML(messages).force_encoding(Encoding::UTF_8)
    response = {messages: messages}
    return response.to_json 
  end

  get '/messages/month/:date' do |date|
    if !session[:user_email]
      error 401
    end
    dateArray = date.split('-')
    year = dateArray[0]
    month = dateArray[1]
    messages = DataStore.where_month(year, month)
    messages = CGI::escapeHTML(messages).force_encoding(Encoding::UTF_8)
    response = {messages: messages}
    return response.to_json 
  end

  get '/messages/:id' do |id|
    if !session[:user_email]
      error 401
    end
    DataStore.find(id)
  end

  post '/messages/:id/edit' do |id|
    if !session[:user_email]
      error 401
    end
    message = {}
    time = params[:date].to_i
    if params[:time] and !params[:time].empty?
      hours, minutes = params[:time].split(":").map{|str| str.to_i}  
      seconds = hours * 60 * 60 + minutes * 60
      time += seconds
    end
    message[:time] = time 
    message[:message] = CGI::escapeHTML(params[:message]).force_encoding(Encoding::UTF_8)
    message[:service] = params[:service]
    DataStore.update(id, message)
    redirect to '/calendar'
  end

end

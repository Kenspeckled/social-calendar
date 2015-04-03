class SocialPlatform
  
  def send(message)
    #check service type and then do the right method
    if message[:service] == twitter
      twitter = TwitterAPIWrapper.new
      twitter.tweet(message)
    end
  end
  
end

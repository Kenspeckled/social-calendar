class SocialPlatform
  
  def send(message)
    #check service type and then do the right method
    if message[:service] == twitter
      tweet(message)
    end
  end
  
  def tweet(message)
    #tweet
  end
  
  
end

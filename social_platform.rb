require './twitter_api_wrapper'
class SocialPlatform
  
  def self.send_to_social_service(message_hash)
    if !message_hash[:service] or message_hash[:service].empty?
      raise "No service defined"
    end
    #check service type and then do the right method
    if message_hash[:service] == 'twitter'
      twitter = TwitterAPIWrapper.new
      twitter.tweet(message_hash[:message])
    end
  end
  
end

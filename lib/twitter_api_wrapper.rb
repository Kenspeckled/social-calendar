require 'oauth'
require 'yaml'
require 'cgi'
class TwitterAPIWrapper

  def self.tweet(message)
    tweet_uri = 'https://api.twitter.com/1.1/statuses/update.json'
    status = "#{tweet_uri}?status=#{CGI.escape(message)}"
    client = TwitterAPIWrapper.create_access_token
    client.post(status)
  end

  private

  def self.create_access_token
    secrets = YAML.load_file(File.join(File.dirname(__FILE__),'../secrets.yml'))
    consumer = OAuth::Consumer.new(secrets['API_Key'], secrets['API_Secret'], { site: "http://api.twitter.com", scheme: :header })
    OAuth::AccessToken.from_hash(consumer, { oauth_token: secrets['oauth_token'], oauth_token_secret: secrets['oauth_token_secret'] })
  end


end

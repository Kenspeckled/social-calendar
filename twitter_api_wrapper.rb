require 'oauth'
require 'yaml'
class TwitterAPIWrapper
  attr_reader :client, :secrets

  def initialize 
    @secrets = YAML.load_file('secrets.yml')
    @client = create_access_token
  end

  def tweet(message)
    tweet_uri = 'https://api.twitter.com/1.1/statuses/update.json'
    status = "#{tweet_uri}?status=#{URI.escape(message)}"
    client.post(status)
  end

  private

  def create_access_token
    consumer = OAuth::Consumer.new(secrets['API_Key'], secrets['API_Secret'], { site: "http://api.twitter.com", scheme: :header })
    OAuth::AccessToken.from_hash(consumer, { oauth_token: secrets['oauth_token'], oauth_token_secret: secrets['oauth_token_secret'] })
  end


end

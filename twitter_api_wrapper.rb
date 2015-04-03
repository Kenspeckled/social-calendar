class TwitterAPIWrapper
  attr_reader :client

  def initalize
    secrets = YAML.load_file('secrets.yml')
    @client = create_access_token(secrets)
  end

  def tweet(message)
    client.request(:post, '')
  end

  private

  def create_access_token(secrets)
    consumer = OAuth::Consumer.new("APIKey", "APISecret", { site: "http://api.twitter.com", scheme: :header })
    OAuth::AccessToken.from_hash(consumer, { oauth_token: secrets['oauth_token'], oauth_token_secret: secrets['oauth_token_secret'] })
  end


end

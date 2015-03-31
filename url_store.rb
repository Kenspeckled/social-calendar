require 'redis'
class URLStore

  @redis = Redis.new

  def self.find(key)
    @redis.hget("key:#{key}", "url")
  end

  def self.set(args)
    name = args[:name]
    key = args[:key]
    url = args[:url]
    if !name or !key or !url
      raise "Not all values provided"
    end
    @redis.sadd("keys", key) 
    @redis.hset("key:#{key}", "name", name)
    @redis.hset("key:#{key}", "url", url)
    @redis.hset("key:#{key}", "created_at", Time.now)
  end

  def self.get_all
    @redis.smembers("keys").map do |key|
      url_hash = @redis.hgetall("key:#{key}")
      url_hash['key'] = key
      url_hash
    end
  end

end

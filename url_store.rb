require 'redis'
class URLStore

  @redis = Redis.new

  def self.find(key)
    @redis.hget(key, "url")
  end

  def self.set(key, value)
    @redis.hset(key, "url", value)
  end

end

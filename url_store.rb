require 'redis'
class URLStore

  @redis = Redis.new

  def self.find(key)
    @redis.hget("key:#{key}", "long_url")
  end

  def self.set(key, value)
    @redis.sadd("keys", key)
    @redis.hset("key:#{key}", "long_url", value)
  end

  def self.get_all
    @redis.smembers("keys").map do |key|
      info = @redis.hgetall("key:#{key}")
      {key: key, long_url: info['long_url'], counter: info['counter']}
    end
  end

end

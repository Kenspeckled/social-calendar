module Analytics

  @redis = Redis.new

  def self.add_to_counter(key)
    @redis.hincrby("key:#{key}", "counter", 1)
  end

end

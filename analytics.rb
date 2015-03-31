module Analytics

  @redis = Redis.new

  def self.add_to_counter(key)
    @redis.hincrby(key, "counter", 1)
  end

end

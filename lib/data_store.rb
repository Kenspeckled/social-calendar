require 'redis'
class DataStore

  @redis = Redis.new

  def self.find(id)
    object = @redis.hgetall("calendar_message:#{id}")
    object["id"] = id
    return object
  end

  def self.update(id, args)
    time = args[:time]
    time_since_epoch = Time.at(time).to_i if time
    puts "Time", time
    puts "Time Since Epoch", time_since_epoch 
    message = args[:message]
    service = args[:service]
    if !id or !time_since_epoch or !message or !service
      raise "Not all values provided"
    end
    @redis.hmset(
      "calendar_message:#{id}",
      "time", time_since_epoch,
      "message", message,
      "service", service
    )
    @redis.sadd("cm:#{Time.at(time_since_epoch).strftime("%Y%m%d")}", id)
  end

  def self.create(args)
    id = @redis.get("calendar_message_id")
    if self.update(id, args)
      @redis.incr("calendar_message_id")
    end
  end

  def self.where_date(year, month, day)
    dateInt = Time.new(year, month, day).strftime("%Y%m%d")
    message_ids = @redis.smembers "cm:" + dateInt
    message_ids.map{|id| DataStore.find(id) }
  end

end

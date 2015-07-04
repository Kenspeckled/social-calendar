require 'redis'
require 'cgi'
class DataStore

  @redis = Redis.new

  def self.find(id)
    object = @redis.hgetall("calendar_message:#{id}")
    object["id"] = id if object
    object['message'] = CGI::escapeHTML(object['message'].to_s.force_encoding(Encoding::UTF_8))
    return object
  end

  def self.update(id, args)
    time = args[:time]
    time_since_epoch = Time.at(time).to_i if time
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
    @redis.sadd("cm_month:#{Time.at(time_since_epoch).strftime("%Y%m")}", id)
    @redis.sadd("cm_day:#{Time.at(time_since_epoch).strftime("%Y%m%d")}", id)
  end

  def self.create(args)
    id = @redis.get("calendar_message_id")
    if !id # this might be the first time this has been set
      id = 1
      @redis.set("calendar_message_id", id)
    end
    if self.update(id, args)
      @redis.incr("calendar_message_id")
    end
  end

  def self.where_date(year, month, day)
    dateInt = Time.new(year, month, day).strftime("%Y%m%d")
    message_ids = @redis.smembers "cm_day:" + dateInt
    message_ids.map{|id| DataStore.find(id) }
  end

  def self.where_month(year, month)
    dateInt = Time.new(year, month, 1).strftime("%Y%m")
    message_ids = @redis.smembers "cm_month:" + dateInt
    message_ids.map{|id| DataStore.find(id) }
  end

end

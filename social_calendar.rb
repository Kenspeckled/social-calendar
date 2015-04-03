require 'redis'
class SocialCalendar

  @redis = Redis.new

  def self.set(args)
    scheduled_time = args[:scheduled_time]
    time_since_epoch = scheduled_time.to_i
    message = args[:message]
    service = args[:service]
    if !scheduled_time or !message or !service
      raise "Not all values provided"
    end
    @redis.incr("social_calendar_id")
    id = @redis.get("social_calendar_id")
    @redis.hmset("social_calendar:#{id}",
      "scheduled_time", scheduled_time,
      "message", message,
      "service", service,
      "created_at", Time.now)
  end

  def self.get_all

  end

end
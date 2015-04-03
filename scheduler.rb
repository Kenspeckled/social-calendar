require './social_platform'
class Scheduler
  @should_poll = false

  def self.poll 
    return if !@should_poll
    send_messages
    sleep 60
    poll 
  end

  def self.start_polling
    @should_poll = true
    poll
  end

  def self.stop_polling
    @should_poll = false
  end

  private
  
  @messages = [
    {time: Time.now, message: "Hello", service: 'twitter'},
    {time: Time.now + 65, message: "World", service: 'twitter'},
    {time: Time.now + 130, message: "Just Tweeting", service: 'twitter'},
  ]

  def self.send_messages
    # FIXME: messages needs to access db
    @messages.select do |message|
      message_time = minutes_since_epoch(message[:time])
      current_time = minutes_since_epoch(Time.now)
      if message_time == current_time
        SocialPlatform.send_to_social_service(message)
      end
    end
  end

  def self.minutes_since_epoch(time_string)
    time_string.to_i / 60
  end

end

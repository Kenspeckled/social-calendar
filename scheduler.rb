class Scheduler
  attr_reader :jobs

  #we'll get this from the database
  def initialise
    a = {time: Time.now, content:"Hello", service: :twitter}
    @messages = [a]
  end

  def recur
    messages.select do |message|
      message_time = minutes_since_epoch(message[:time])
      current_time = minutes_since_epoch(Time.now)
      if message_time == current_time
        SocialPlatform.send(message)
      end
    end
    sleep 60
    recur
  end

  private

  def minutes_since_epoch(time_string)
    time_string.to_i / 60
  end



end
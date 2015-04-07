require_relative './social_platform'
require_relative './data_store'
class Scheduler
  @should_poll = false
  @poller = nil

  def self.poll
    return if !@should_poll
    puts "\nSCHEDULER: Polling\n"
    send_messages
    sleep rand(40..60) # hide the fact this is automated 
    poll
  end

  def self.start_polling
    @should_poll = true
    @poller = Thread.new do 
      Scheduler.poll
    end
    @poller.join
  end

  def self.stop_polling
    @should_poll = false
    @poller.exit if @poller
  end

  private

  def self.send_messages
    messages = DataStore.where_date(Time.now.year, Time.now.month, Time.now.day)
    puts "\nSCHEDULER: Lining up today's messages:\n", messages, "\n"
    messages.select do |message|
      message_time = minutes_since_epoch(message["time"])
      current_time = minutes_since_epoch(Time.now)
      if message_time == current_time
        puts "\nSCHEDULER: Sending\n", message
        SocialPlatform.send_to_social_service(message)
      end
    end
  end

  def self.minutes_since_epoch(time_string)
    time_string.to_i / 60
  end

end

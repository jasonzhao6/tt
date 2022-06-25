#!/usr/bin/env ruby
#
# Tomato Timer (TT)
# -----------------
# A ruby script that announces 'X minutes in.' every 5 minutes.
# I use it as a reminder to focus and be aware of time passing.
# This was inspired by the paid app https://www.centered.app/.
#
# In addition to being a timer, it can also be used as an alarm.
#
# HOW TO:
# In `.bash_profile`, add `alias tt='[/path/to]/tt.rb'`.
# Then in a terminal, run `tt [do this one thing]` to start timer.
# Or run `tt [a number in minutes]` to start alarm countdown.
#

class TT
  DEBUG = false
  VOLUME = 0.7 # Between 0.0 - 1.0
  MINUTE = DEBUG ? 2 : 60 # Seconds
  INTERVAL = (DEBUG ? 1 : 5) * MINUTE
  OUTRO_THTRESHOLD = (DEBUG ? 3 : 15) * MINUTE

  def initialize(message)
    @message = message
    @timer = 0
  end

  def start
    # If the argument is a number, behave as an alarm, with unit in minutes
    begin
      alarm_in_minutes = @message.to_i
      if alarm_in_minutes.to_s == @message
        say("Setting alarm for #{time_with_unit(alarm_in_minutes * MINUTE)}.")
        sleep alarm_in_minutes * MINUTE
        say("#{time_with_unit(alarm_in_minutes * MINUTE)} passed.", volume: 1)
        exit
      end
    rescue SignalException => e
      exit
    end

    # Otherwise, behave as a tomato timer
    begin
      unless @message.empty?
        say(intro)
        sleep 0.4
        say("It's time to '#{@message}.")
      end

      loop
    rescue SignalException => e
      say(outro) unless @message.empty?
    end
  end

  private

  def say(message, volume: VOLUME)
    `say [[volm #{volume}]] #{message}`
  end

  def loop
    sleep INTERVAL

    @timer += INTERVAL
    puts status = "#{time_with_unit(@timer)} in."
    say(status)

    loop
  end

  def time_with_unit(seconds)
    if seconds >= MINUTE
      minutes = seconds / MINUTE
      "#{minutes} minute#{minutes > 1 ? 's' : ''}"
    else
      "#{@timer} seconds"
    end
  end

  def intro
    [
      'Ready to focus.',
      'Ready to dive in.',
      'Let’s center ourselves.',
      'Let’s get into a state of flow.',
    ].sample
  end

  def outro
    if @timer >= OUTRO_THTRESHOLD
      [
        'Nice work. Reward yourself for getting this task done.',
        'Stand up and stretch. Let yourself feel gratitude for the work you did.',
        'Well done. Take a moment to focus your eyes on the distance away from the screen.',
      ].sample
    else
      [
        "There. Very good.",
        'Hey, nicely done.',
        'Yes, good work.',
      ].sample
    end
  end
end

TT.new(ARGV.join(' ')).start

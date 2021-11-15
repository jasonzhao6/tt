#!/usr/bin/env ruby
#
# Tomato Timer (TT)
# A ruby script that announces 'X minutes in.' every 5 minutes.
# I use it as a subtle reminder to focus and be aware of time passing.
# This was inspired by and a poor man's version of https://www.centered.app/.
#
# HOW TO:
# In a terminal, run `[/path/to]/tt.rb [do this one thing]`.
# When you are done, exit with `ctrl + c`.
# - or -
# In `.bash_profile`, add `alias tt='[/path/to]/tt.rb'`.
# Then in a terminal, run `tt [do this one thing]`.

class TT
  DEBUG = false
  VOLUME = 0.5 # Multiplier
  MINUTE = DEBUG ? 2 : 60 # Seconds.
  INTERVAL = DEBUG ? 2 : 5 * MINUTE
  OUTRO_THTRESHOLD = DEBUG ? 3 * MINUTE : 15 * MINUTE

  def initialize(message)
    @message = message
    @timer = 0
  end

  def start
    unless @message.empty?
      say(intro)
      sleep 0.4
      say("It's time to '#{@message}.")
    end
    loop
  rescue SignalException => e
    say(outro) unless @message.empty?
  end

  private

  def say(message)
    `say [[volm #{VOLUME}]] #{message}`
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

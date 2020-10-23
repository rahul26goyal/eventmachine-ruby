require 'rubygems'
require 'eventmachine'

def defer1()
end

def start
  puts "1. Starting #{Thread.current}:  process: #{Process.pid}: #{Time.now}"
  EM.run {
    EM.add_timer(5) do #run this after 5 seconds assuming reactor loop in not blocked.
      puts "Main #{Thread.current}:  process: #{Process.pid}: #{Time.now}"
      EM.stop()
    end

    EM.next_tick do
      puts "next tick1 called.."
    end
    
    EM.next_tick do
      puts "next tick2 called.."
    end
    
    EM.next_tick do
      puts "next tick3 called.."
    end
  }
end

start
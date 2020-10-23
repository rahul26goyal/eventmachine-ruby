require 'rubygems'
require 'eventmachine'

def register()
  puts "register...."
  i = 0
  while i < 2
    puts "i: #{i}"
    i = i + 1
    sleep 1
  end
end


def start
  puts "step 1 reactor_running: #{EM.reactor_running?}"
  
  EM.run {
    puts "step 2 reactor_running: #{EM.reactor_running?}"
    
    EM.next_tick do #this will only get triggere after the current reactor loop is finished..
      puts "next tick.."
      puts "step 3 reactor_running: #{EM.reactor_running?}"
      EM.stop() #after this, reactor will stop running.
    end

    register()
    register()
    #register()
    puts "step 4 reactor_running: #{EM.reactor_running?}"
  }
  puts "step 5 reactor_running: #{EM.reactor_running?}"
  puts "Done.."
end

start
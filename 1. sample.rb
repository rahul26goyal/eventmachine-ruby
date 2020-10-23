$eventmachine_library = :pure_ruby
require 'eventmachine'

def register()
  puts "register...."
  i = 0
  while i < 2
    puts "i: #{i}"
    i = i + 1
    #sleep 1
  end
end

def register2()
  puts "register2...."
  i = 0
  while i < 2
    puts "i: #{i}"
    i = i + 1
    sleep 1
  end
end


def start()
  #Process.daemon
  puts "starting EM Run in processs...#{Process.pid}"
  EM.run {
    puts "starting reactor...."
    #handle graceful shutdown.
    Signal.trap("INT")  {
      puts "quitting..."
      EM.stop()
    }

    #kick start functions in reactor loop.
    #there are not events but synchronoue execution code in reactor.
    register()
    #register2()
    puts "all the function in reactor are executed...waiting infinite..."    
  }
  puts "EM is stopped...."
end

start()
puts "we will never reach here unless someones quits.."
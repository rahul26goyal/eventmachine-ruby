require 'rubygems'
require 'eventmachine'

def defer_proc()
  Proc.new {  
    puts "Defer thread: #{Thread.current}:  process: #{Process.pid}: #{Time.now}"
    puts "sleeping..."
    sleep 5
    puts "awakke...."
  }
end

def callback_proc()
  Proc.new { |result|
    puts "Done with #{result}"
  }
end

def start
  puts "1. Starting #{Thread.current}:  process: #{Process.pid}: #{Time.now}"
  EM.run {
    EM.add_timer(7) do  #times should be greated then the execution of defer as we stop in this call.
      puts "Main thread: #{Thread.current}:  process: #{Process.pid}: #{Time.now}"
      EM.stop()
    end
    
    #each defer run on a different thread...
    EM.defer(defer_proc(), callback_proc()) 
    EM.defer(defer_proc(), callback_proc())
    EM.defer(defer_proc(), callback_proc())
  }
end

start
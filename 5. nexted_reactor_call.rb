require 'rubygems'
require 'eventmachine'

def defer_proc(x, y)
  Proc.new {  
    puts "Defer thread: #{Thread.current}:  process: #{Process.pid}: #{Time.now}"
    x << y
    @z << 1
    EM.add_timer(y-3) do
      puts "I am Reactor Thread: #{Thread.current} added by defer. :Time #{Time.now}:"
      sleep 20 #this will block everything in reactor thread...but other defer thread will contines to fucntion.
    end
    puts "Defer Thread: #{Thread.current}: sleeping for Y sec: #{y}"
    sleep y
    x << y+1
    puts " Defer Thread: #{Thread.current} : Time #{Time.now}: am awakke....moving to callback function.."
    x
  }
end

def callback_proc()
  Proc.new { |result|
    puts "Callback/Reactor Thread: #{Thread.current}: :Time #{Time.now}: Done with callback with result: #{result}"
  }
end

def start
  x = []
  @z = []
  stop_after = 20
  puts "1. Starting #{Thread.current}:  process: #{Process.pid}: #{Time.now}"
  EM.run {
    EM.add_timer(9) do
      puts "Reactor thread: #{Thread.current} after 9 sec:  process: #{Process.pid}: :Time #{Time.now}:"
      puts "Reactor: going to sleep for 20 sec..should block the next ticks until i wake up."
      puts "Reactor: value of x: #{x}"
      puts "Reactor 3sec delay: value of z: #{@z}"
      puts "Reactor: woke up: will complete the pending events and die.." #whichever threads have not finished will die immediately.
      puts "Reactor: value of x: #{x}"
      EM.stop()
    end

    EM.add_timer(5) do
      puts "Reactor Thread: #{Thread.current}after 3sec delay: :Time #{Time.now}: value of x: #{x}"
      puts "Reactor 3sec delay: value of z: #{@z}"
      @z << 2222
    end

    #each defer run on a different thread...
    EM.defer(defer_proc(x,5), callback_proc()) 
    EM.defer(defer_proc(x, 10), callback_proc())
    EM.defer(defer_proc(x, 15), callback_proc())
    EM.defer(defer_proc(x, 30), callback_proc()) #this might not get execution fulle as stop_after is 20.
  }
end

start

def register()
  puts "thread: #{Thread.current}:: register...."
  i = 0
  while i < 2
    #puts "i: #{i}"
    i = i + 1
    sleep 1
  end
end

def defer_thread()
  puts " thread: #{Thread.current}: starting thread..."
  Thread.new {
    while(true)
      puts "i m in defer_thread: #{Thread.current}: "
      sleep 8
    end
  }
  puts " thread: #{Thread.current}: completed starting defer thread.."
end

def start_reactor
  
  Signal.trap("INT")  {
    puts " thread: #{Thread.current}: quitting..."
    return 0
  }
  
  defer_thread()
  while(true)
    puts "Reactort Thread: #{Thread.current}."
    sleep 5
    #register()
  end
end

start_reactor


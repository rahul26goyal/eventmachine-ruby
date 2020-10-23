require 'rubygems'
require 'eventmachine'

class Echo < EventMachine::Connection
  def post_init
    puts "send request: "
    send_data 'Hello'
  end

  def receive_data(data)
    puts "receive_data"
    puts data
  end
end

EventMachine.run {
  puts "start client "
  EventMachine::connect '127.0.0.1', 8081, Echo
  puts "request finished......"
}
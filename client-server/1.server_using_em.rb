#!/usr/bin/env ruby
#
# server_1

require 'rubygems'
require 'eventmachine'


module EchoServer
  def post_init
    puts "-- New Client Connection found!!"
  end
  
  def receive_data(data)
    send_data ">>> Echo #{data}"
  end
end

def start_server
  EventMachine.run {
    EventMachine::start_server "127.0.0.1", 8081, EchoServer
    puts 'running echo server on 8081'
  }
end

start_server


require 'rubygems'
require 'eventmachine'
require 'evma_httpserver'

class Handler  < EventMachine::Connection
  include EventMachine::HttpServer
  @@concurrency = 0
  @@request = 0
  def process_http_request
    resp = EventMachine::DelegatedHttpResponse.new( self )
    @@request += 1
    puts " Request Number Received: #{@@request}"
    # Block which fulfills the request
    operation = process_proc(resp)

    # Callback block to execute once the request is fulfilled
    callback = callback_proc()

    # Let the thread pool (20 Ruby threads) handle request #anything more then that will be queued here until a thred is free.
    EM.defer(operation, callback)
  end
  
  def process_proc(resp)
    Proc.new {
      @@concurrency += 1
      puts ":::::::::::::::::::::Concurrency of System: #{@@concurrency}"
      sleep 10 # simulate a long running request
      resp.status = 200
      resp.content = "Hello World!"
      resp
    }
  end

  def callback_proc()
    Proc.new { |resp|
      resp.send_response
      puts "Response Sent.."
      @@concurrency -= 1
    }
  end
end

EventMachine::run {
  #this will accept all the incoming request and put in the eventloop to get porcessed.
  #as the master/ Reacor thread become free, it will start to process the requests.
  EventMachine::start_server("0.0.0.0", 8081, Handler)
  puts "Server Listening on 8081..."
}

# Benchmarking results:
#
# > ab -c 5 -n 10 "http://127.0.0.1:8081/"
# > Concurrency Level:      5
# > Time taken for tests:   4.21405 seconds
# > Complete requests:      10
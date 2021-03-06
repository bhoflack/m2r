# require 'rubygems'
# require 'ruby-debug'
# Debugger.start
$: << File.expand_path(File.dirname(__FILE__) + '/..')
require 'connection'

sender_id = "C2256F34-14A1-45DD-BB73-97CAE25E25B4"

conn = Mongrel2::Connection.new(sender_id, "tcp://127.0.0.1:9997",
                          "tcp://127.0.0.1:9996")

while true
  puts "WAITING FOR REQUEST"

  req = conn.recv

  if req.is_disconnect
    puts "DICONNECT"
    next
  end

  response = "<pre>\nSENDER: %s\nIDENT:%s\nPATH: %s\nHEADERS:%s\nBODY:%s</pre>" % [
      req.sender.inspect, req.conn_id.inspect, req.path.inspect, 
      JSON.generate(req.headers).inspect, req.body.inspect]

  puts response

  conn.reply_http(req, response)
end
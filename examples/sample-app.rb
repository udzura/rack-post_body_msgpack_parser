$:.unshift './lib'

require 'sinatra'
require 'rack-post_body_msgpack_parser'

configure do
  use Rack::PostBodyMsgpackParser, override_params: true
  set :run, false
end

post '/' do
  content_type 'text/plain'
  "Your post result is: #{params.inspect}"
end

Thread.new do
  Sinatra::Application.run!
end

puts <<BANNER
##################################
# MessagePack data post examples #
##################################

BANNER

require 'msgpack'
require 'json'
require 'faraday'

until (TCPSocket.new("localhost", 4567) rescue false)
end

conn = Faraday.new(url: "http://localhost:4567")

sample1 = [MessagePack.pack({foo: "sample"}), 'application/x-msgpack']
sample2 = [MessagePack.pack({example: "DATA", some: ["array", 1, 2, 99], nest: {ed: "resource"}}), 'application/x-msgpack']
sample3 = [JSON.dump({foo: "sample"}), 'application/json']
sample4 = ["foo=sample", nil]

[sample1, sample2, sample3, sample4].each do |body, content_type|
  puts "request body: #{body.inspect}"
  puts "requesting..."
  res = conn.post do |req|
    req.url '/'
    req.headers['Content-Type'] = content_type if content_type
    req.body = body
  end

  puts "respons body is:", res.body, "-" * 32, ''
end

exit

# Rack::PostBodyMsgpackParser

Parse MessagePack-formatted POST data into Ruby object

## Installation

Add this line to your application's Gemfile:

    gem 'rack-post_body_msgpack_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-post_body_msgpack_parser

## Usage

Just `use` it

```ruby
require 'sinatra'
require 'rack/post_body_msgpack_parser'
use Rack::PostBodyMsgpackParser

post '/' do
  request.env['rack.request.form_hash_msgpack'].inspect
end
```

```ruby
require 'faraday'
require 'msgpack'

cli = Faraday.new(url: "http://localhost:4567")
res = cli.post do |req|
  req.url '/'
  req.headers['Content-Type'] = 'application/x-msgpack'
  req.body = MessagePack.pack({foo: 123})
end
p res.body
#=> "{\"foo\"=>123}"
```

`use Rack::PostBodyMsgpackParser` just put parsed msgpack data
into `env['rack.request.form_hash_msgpack']`.

If you want to use msgpack value as just merged params (in other word, request.POST)
pass the option as `use Rack::PostBodyMsgpackParser, override_params: true`

## Runnable Examples

You can run and see POST sample as:

```bash
bundle install
ruby examples/sample-app.rb
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

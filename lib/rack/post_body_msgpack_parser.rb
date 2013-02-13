# Copied from a great job
# https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/post_body_content_type_parser.rb

require "rack"
require "msgpack"

module Rack
  class PostBodyMsgpackParser
    CONTENT_TYPE = 'CONTENT_TYPE'.freeze
    POST_BODY = 'rack.input'.freeze
    FORM_INPUT = 'rack.request.form_input'.freeze
    FORM_HASH = 'rack.request.form_hash'.freeze
    FORM_HASH_MSGPACK = 'rack.request.form_hash_msgpack'.freeze

    APPLICATION_MSGPACK_MIMES = ["application/x-msgpack", "application/x-mpac"]

    def initialize(app, options={})
      @app = app
      @options = options
    end

    def override_params?
      !! @options[:override_params]
    end

    def call(env)
      if APPLICATION_MSGPACK_MIMES.include?(Rack::Request.new(env).media_type) && (body = env[POST_BODY].read).length != 0
        env[POST_BODY].rewind # somebody might try to read this stream
        body = MessagePack.unpack body
        if override_params?
          env.update(FORM_HASH => body, FORM_INPUT => env[POST_BODY])
        end
        env.update(FORM_HASH_MSGPACK => body)
      end
      @app.call(env)
    end
  end
end

require "rack/post_body_msgpack_parser/version"

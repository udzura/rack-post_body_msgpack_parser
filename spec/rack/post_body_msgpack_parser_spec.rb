require 'spec_helper'
require 'json'
require "rack/post_body_msgpack_parser"

describe Rack::PostBodyMsgpackParser do
  let(:msgpack_data) { MessagePack.pack({"the_key" => "THE VALUE", "sample" => [1, 2, 3]}) }
  let(:json_data)    { JSON.dump({"the_key" => "THE VALUE", "sample" => [1, 2, 3]}) }

  context 'not override_params' do
    before do
      mock_app do
        use Rack::PostBodyMsgpackParser

        helpers do
          def msgpack_params
            @_params ||= request.env['rack.request.form_hash_msgpack']
          end
        end

        post '/test-it' do
          if msgpack_params
            "OK: keys: #{msgpack_params.keys}, values: #{msgpack_params.values}"
          else
            "No Data"
          end
        end
      end
    end

    it "should ignore post when posted normally" do
      post "/test-it", {foo: "bar"} do |response|
        response.body.should == "No Data"
      end
      last_request.params.should have(1).pair
    end

    it "should accept post by msgpack data" do
      header 'Content-Type', 'application/x-msgpack'
      post "/test-it", {}, {:input => msgpack_data} do |response|
        response.body.should include "OK"
        response.body.should include %q(keys: ["the_key", "sample"])
        response.body.should include %q(values: ["THE VALUE", [1, 2, 3]])
      end
      last_request.params.should be_empty
    end

    it "should ignore post by json data" do
      header 'Content-Type', 'application/json'
      post "/test-it", {}, {:input => json_data} do |response|
        response.body.should == "No Data"
      end
      last_request.params.should be_empty
    end
  end

  context 'not override_params' do
    before do
      mock_app do
        use Rack::PostBodyMsgpackParser, override_params: true

        post '/test-it' do
          builder = ''
          params.each_pair do |key, value|
            builder << "#{key.to_s}=#{value.inspect} "
          end
          "OK: #{builder}"
        end
      end
    end

    it "should ignore post when posted normally" do
      post "/test-it", {foo: "bar"} do |response|
        response.body.should include %q(foo="bar")
      end
      last_request.params.should have(1).pair
    end

    it "should accept post by msgpack data" do
      header 'Content-Type', 'application/x-msgpack'
      post "/test-it", {}, {:input => msgpack_data} do |response|
        response.body.should include %q(the_key="THE VALUE")
        response.body.should include %q(sample=[1, 2, 3])
      end
      last_request.params.should have(2).pair
    end

    it "should ignore post by json data" do
      header 'Content-Type', 'application/json'
      post "/test-it", {}, {:input => json_data} do |response|
        response.body.length.should == 4
        response.body.should_not include %q(the_key="THE VALUE")
        response.body.should_not include %q(sample=[1, 2, 3])
      end
      last_request.params.should be_empty
    end
  end
end

# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/post_body_msgpack_parser/version'

Gem::Specification.new do |gem|
  gem.name          = "rack-post_body_msgpack_parser"
  gem.version       = Rack::PostBodyMsgpackParser::VERSION
  gem.authors       = ["Uchio KONDO"]
  gem.email         = ["udzura@udzura.jp"]
  gem.description   = %q{Parse post data by MessagePack}
  gem.summary       = %q{Parse post data by MessagePack}
  gem.homepage      = "https://github.com/udzura/rack-post_body_msgpack_parser"

  gem.files         = `git ls-files`.split($/)
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'rack', '>= 0'
  gem.add_runtime_dependency 'msgpack', '>= 0'
  gem.add_development_dependency 'rake', '>= 0'
  gem.add_development_dependency 'rspec', '>= 0'
  gem.add_development_dependency 'pry', '>= 0'
  gem.add_development_dependency 'rack-test', '>= 0'
  gem.add_development_dependency 'sinatra', '>= 1.3.0'
  gem.add_development_dependency 'sinatra-contrib', '>= 0'

  gem.add_development_dependency 'faraday'
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'layer/api/version'

Gem::Specification.new do |spec|
  spec.name          = "layer-api"
  spec.version       = Layer::Api::VERSION
  spec.authors       = ["Jake Kelly"]
  spec.email         = ["jake.kelly10@gmail.com"]
  spec.license       = "MIT"

  spec.summary       = "A ruby toolkit for Layer's Platform API (https://developer.layer.com/docs/platform)"
  spec.description   = "Simple wrapper for the Layer Platform API"
  spec.homepage      = "https://github.com/cakejelly/layer-api"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3", ">= 3.3.0"
  spec.add_development_dependency "vcr", "~> 2.9", ">= 2.9.3"
  spec.add_development_dependency "webmock", "~> 1.21", ">= 1.21.0"
  spec.add_development_dependency "pry", "~> 0.10.1"

  spec.add_dependency "faraday", "~> 0.9.1"
end

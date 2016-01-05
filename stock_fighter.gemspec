# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stock_fighter/version'

Gem::Specification.new do |spec|
  spec.name          = "stock_fighter"
  spec.version       = StockFighter::VERSION
  spec.authors       = ["Jing Yang"]
  spec.email         = ["ditsing@gmail.com"]

  spec.summary       = %q{Better stockfighter.io API, friendly to scripting.}
  spec.description   = %q{API for http://stockfighter.io. Run bin/console and start playing!}
  spec.homepage      = "http://github.com/ditsing/stock_fighter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httparty", "~> 0.13.7"
  spec.add_runtime_dependency "json", "~> 1.8.3"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end

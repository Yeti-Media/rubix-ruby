# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
#require 'rubix/api/version'

Gem::Specification.new do |spec|
  spec.name          = "rubix-api"
  spec.version       = '0.0.2'
  spec.authors       = ["Yeti Media"]
  spec.email         = ["nicolas55ar@gmail.com"]
  spec.description   = "Wrapper for Rubix Api"
  spec.summary       = "Rubix gem"
  spec.homepage      = "http://github.com/Yeti-Media/rubix-ruby"
  spec.license       = "MIT"

  spec.files            = `git ls-files`.split($\)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday'
  spec.add_dependency 'json'
  
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'json'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end

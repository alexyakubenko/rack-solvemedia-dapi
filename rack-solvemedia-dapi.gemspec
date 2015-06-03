# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/solvemedia/dapi/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-solvemedia-dapi"
  spec.version       = Rack::Solvemedia::DAPI::VERSION
  spec.authors       = ["Tyler Cunnion"]
  spec.email         = ["tyler@solvemedia.com"]
  spec.description   = %q{Solve Media DAPI}
  spec.summary       = %q{Rack middleware for Solve Media's data API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'multi_json', '~> 1.10'
end

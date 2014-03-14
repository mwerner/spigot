# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spigot/version'

Gem::Specification.new do |spec|
  spec.name          = "spigot"
  spec.version       = Spigot::VERSION
  spec.authors       = ["Matthew Werner"]
  spec.email         = ["m@mjw.io"]
  spec.description   = %q{Spigot provides a clean interface translating API data into context relevant objects}
  spec.summary       = 'Spigot is a tool to parse and format data for the creation of ruby objects'
  spec.homepage      = "http://mwerner.github.io/spigot/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = Dir.glob("spec/**/*")
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '~> 3.0'

  spec.add_development_dependency "bundler",   '~> 1.3'
  spec.add_development_dependency "rake",      '~> 10.0'
  spec.add_development_dependency "hashie",    '~> 2.0'
  spec.add_development_dependency "simplecov", '~> 0.7'
  spec.add_development_dependency "rspec",     '~> 2.13'
  spec.add_development_dependency "sqlite3",   '~> 1.3'
end

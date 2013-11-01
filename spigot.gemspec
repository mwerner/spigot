# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spigot/version'

Gem::Specification.new do |spec|
  spec.name          = "spigot"
  spec.version       = Spigot::VERSION
  spec.authors       = ["Matthew Werner"]
  spec.email         = ["m@mjw.io"]
  spec.description   = %q{Spigot provides a clean interface to translate API data into context relevant objects}
  spec.summary       = spec.description
  spec.homepage      = "http://github.com/mwerner/spigot"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = Dir.glob("spec/**/*")
  spec.require_paths = ["lib"]

  spec.add_dependency 'json'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency 'hashie'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'activerecord'
end

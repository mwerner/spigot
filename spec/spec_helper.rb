require 'rspec'
require 'spigot'
require 'hashie'
require "test/unit"
require "mocha/setup"

Dir[File.join(Spigot.root, "spec/fixtures/**/*.rb")].each {|f| require f}

# Mocked Classes
User = Class.new(Hashie::Mash)

module Wrapper
  Post = Class.new(Hashie::Mash)
end

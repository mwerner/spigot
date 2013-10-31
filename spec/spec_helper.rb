require 'rspec'
require 'spigot'
require 'hashie'
require 'active_record'
require "test/unit"
require "mocha/setup"

%w(fixtures support).each do |dir|
  Dir[File.join(Spigot.root, "spec/#{dir}/**/*.rb")].each {|f| require f}
end

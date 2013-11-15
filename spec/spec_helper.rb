require 'rspec'
require 'spigot'
require 'hashie'
require 'active_record'
require "test/unit"
require "mocha/setup"

%w(fixtures support).each do |dir|
  Dir[File.join(Spigot.root, "spec/#{dir}/**/*.rb")].each {|f| require f}
end

# Mocked Classes
User = Class.new(Hashie::Mash)

class ActiveUser < ActiveRecord::Base
  include Spigot::Base
end

module Wrapper
  Post = Class.new(Hashie::Mash)
end

def with_mapping(name, map)
  before do
    instance_variable_set("@prior_#{name}".to_sym, Spigot.config.translations)
    Spigot.configure{|c| c.translations = map }
  end

  after do
    map_cache = instance_variable_get("@prior_#{name}".to_sym)
    Spigot.configure{|c| c.translations = map_cache }
  end
end

RSpec.configure do |config|
  config.after(:each) do
    ActiveUser.delete_all
    Spigot.config.reset
  end
end

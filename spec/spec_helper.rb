require 'simplecov'
SimpleCov.start

require 'rspec'
require 'spigot'
require 'hashie'
require 'active_record'

require File.join(Spigot.root, 'script/active_record.rb')
Dir[File.join(Spigot.root, 'spec/fixtures/**/*.rb')].each { |f| require f }

# Mocked Classes
User = Class.new(Hashie::Mash) do
  include Spigot::Base
end
Post = Class.new(Hashie::Mash)

class ActiveUser < ActiveRecord::Base
  include Spigot::Base
end

class Event < ActiveRecord::Base
  include Spigot::Base
end

class Profile < ActiveRecord::Base
  include Spigot::Base
end

module Wrapper
  Post = Class.new(Hashie::Mash)
end

RSpec.configure do |config|
  config.after(:each) do
    ActiveUser.delete_all
    Spigot.config.reset
  end
end

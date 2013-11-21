require 'active_record'
require 'spigot'

Spigot.define do
  service :twitter do
    resource :tweet do
      login :username
      href :url do |value|
        "https://twitter.com/tweets/#{value}"
      end
    end
  end
end

Spigot.define do
  service :github do
    resource :user do
      login :username
      href :url do |value|
        "https://github.com/#{value}"
      end
    end
  end
end

ActiveRecord::Base.logger = Spigot.logger
require File.join(Spigot.root, 'spec', 'support', 'active_record')

class ActiveUser < ActiveRecord::Base
  include Spigot::Base
end

user = ActiveUser.create(name: 'Matt', username: 'mttwrnr', token: 'abc123')

require 'active_record'
require 'spigot'

Spigot.define do
  service :twitter do
    resource :tweet do
      login :username
      href  :url
      spigot do
        primary_key :username
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

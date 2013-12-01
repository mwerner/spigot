require 'active_record'
require 'spigot'

Spigot.define do
  service :github do
    resource :user do
      id        :github_id
      full_name :name
      login     :username
      contact do
        address   :address
        telephone do
          work :work_phone
          home :home_phone
        end
        url :homepage do |value|
          "https://github.com/#{value}"
        end
      end
    end

    resource :pull_request do
      id        :id
      title     :title
      body      :body
    end
  end
end

ActiveRecord::Base.logger = Spigot.logger
require File.join(Spigot.root, 'spec', 'support', 'active_record')

class ActiveUser < ActiveRecord::Base
  include Spigot::Base
end

user = ActiveUser.create(name: 'Matt', username: 'mttwrnr', token: 'abc123')

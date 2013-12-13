require 'active_record'
require 'spigot'

Spigot.resource(:active_user) do
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

Spigot.service(:twitter) do
  resource :active_user do
    name      :name
    username  :username
  end
end

ActiveRecord::Base.logger = Spigot.logger
require File.join(Spigot.root, 'spec', 'support', 'active_record')

class ActiveUser < ActiveRecord::Base
  include Spigot::Base
end

user = ActiveUser.create(name: 'Matt', username: 'mwerner', token: 'abc123')

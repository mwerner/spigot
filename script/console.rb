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
  options do
    primary_key :username
  end
end

Spigot.resource(:post) do
  headline :title
  content  :body
  options do
    primary_key :username
  end
end

Spigot.service(:twitter) do
  resource :active_user do
    name      :name
    username  :username
  end
end

ActiveRecord::Base.logger = Spigot.logger
require File.join(Spigot.root, 'script', 'active_record')

class ActiveUser < ActiveRecord::Base
  include Spigot::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  include Spigot::Base
  belongs_to :user
end

ActiveUser.create(name: 'Matt', username: 'mwerner', token: 'abc123')

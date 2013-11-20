require 'spigot'

Spigot.define do
  service :twitter do
    resource :user do
      id       :twitter_id
      name     :name
      username :username
    end
  end
end

Spigot.define do
  service :github do
    resource :user do
      id        :github_id
      full_name :name
      login     :username
      contact do
        address   :address
        telephone :phone
        url :homepage do |value|
          "https://github.com/#{value}"
        end
      end
    end
  end
end





Spigot.configure do |config|
  config.translations = {
    'user' => {
      'full_name' => 'name',
      'login' => 'username'
    }
  }
end

class User
  include Spigot::Base

  attr_reader :name, :username

  def initialize(params={})
    params.each_pair do |k, v|
      instance_variable_set("@#{k}".to_sym, v)
    end
  end

  def self.api_data
    { full_name: 'matthew', login: 'mwerner' }
  end

  def self.build
    new_by_api(:github, api_data)
  end
end

user = User.build
puts user.name
puts user.inspect

require 'spigot'

Spigot.configure do |config|
  config.translations = {
    'user' => {
      full_name: 'name',
      login: 'username'
    }
  }
end

class User
  include Spigot::Base

  attr_reader :name, :login

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

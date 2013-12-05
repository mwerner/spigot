require 'active_record'
require 'spigot'
require 'net/http'
require 'uri'

ActiveRecord::Base.logger = Spigot.logger
ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => ':memory:'
})

ActiveRecord::Schema.define do
  self.verbose = false
  create_table :users, :force => true do |t|
    t.integer :github_id
    t.string  :username
    t.string  :image_url
    t.string  :profile_url
  end
end

class User < ActiveRecord::Base
  include Spigot::Base
end

Spigot.define do
  service :github do
    resource :user do
      id :github_id
      login :username
      avatar_url :image_url
      url :profile_url
      options do
        primary_key :username
      end
    end
  end
end

profile_url = "https://api.github.com/users/mwerner"
puts "Making a request to an external API (Github): #{profile_url}"
response = Net::HTTP.get_response URI.parse(profile_url)
puts "Parse the response:\n `data = JSON.parse(response.body)`"
data = JSON.parse(response.body)

puts "\nIt Returned a whole bunch of data: "
puts "#{data.inspect[0..100]}... etc, etc, etc (#{data.keys.length} more keys received)"

puts "\nWe don't want to use all of it. We can define a map on Spigot:"
puts User.spigot(:github).map.to_hash.inspect
puts "Each key is an attribute received from the API, and the corresponding value is our column name."

puts "\nWe define our primary key in the spigot `User` options, so we know how to check if the record already exists:"
puts User.spigot(:github).options.inspect


puts "\nWe can create a new user with one nice and easy line: `User.find_or_create_by_api(:github, data)`"
puts User.find_or_create_by_api(:github, data).inspect

puts "\nEnjoy!"

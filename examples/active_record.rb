require 'active_record'
require 'spigot'
require 'net/http'
require 'uri'

ActiveRecord::Base.logger = Spigot.logger
require_relative '../script/active_record'

class ActiveUser < ActiveRecord::Base
  include Spigot::Base
end

Spigot.resource :active_user do
  id :github_id
  name :name
  login :username
  gravatar_id :token
  options do
    primary_key :username
  end
end

profile_url = 'https://api.github.com/users/mwerner'
puts "Making a request to an external API (Github): #{profile_url}"
response = Net::HTTP.get_response URI.parse(profile_url)
puts "Parse the response:\n `data = JSON.parse(response.body)`"
data = JSON.parse(response.body)

puts "\nIt returns a whole bunch of data: "
puts "#{data.inspect[0..100]} ... etc, etc, etc (#{data.keys.length} more keys received)"

puts "\nWe don't want to use all of it. Let's define a map on Spigot:"
puts ActiveUser.spigot.map.to_hash.inspect
puts 'Each key is an attribute received from the API, the corresponding value is our column name.'

puts "\nWe define our primary key in the spigot `ActiveUser` options;"
puts 'now we know how to check if the record already exists:'
puts ActiveUser.spigot.options.inspect

puts "\nWe can create a new user with one line: `ActiveUser.find_or_create_by_api(data)`"
puts ActiveUser.find_or_create_by_api(data).inspect

puts "\nThen running it again, we'll see Spigot returns the existing record."
puts ActiveUser.find_or_create_by_api(data).inspect

puts "\nEnjoy!"

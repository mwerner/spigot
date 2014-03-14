require 'active_record'
require 'spigot'
require 'net/http'
require 'uri'

ActiveRecord::Base.logger = Spigot.logger
require_relative '../script/active_record'

class Event < ActiveRecord::Base
  include Spigot::Base
end

class ActiveUser < ActiveRecord::Base
  include Spigot::Base
end

Spigot.define do
  resource :active_user do
    id :github_id
    name :name
    login :username
    gravatar_id :token
    options do
      primary_key :username
    end
  end

  resource :event do
    id   :github_id
    type :name
    actor ActiveUser
    options do
      primary_key :id
    end
  end
end

events_url  = 'https://api.github.com/events'

puts 'We can start off by making a request to get the latest github events'
response = Net::HTTP.get_response URI.parse(events_url)
puts "Parse the response:\n `data = JSON.parse(response.body)`"
event_data = JSON.parse(response.body)

puts "\nIt returns a whole bunch of data: "
puts "#{event_data.inspect[0..100]} ... etc, etc, etc\n\n"

puts 'Lets take the first three events and run them through spigot.'
puts 'We only want a few attributes: id, type and the associated user.'
puts Event.spigot.map.to_hash.inspect

puts "We'll assign a primary key in our options to make sure we don't duplicate events"
puts Event.spigot.options.inspect

puts "\nWe can parse all the events with one nice and easy line: `Event.spigot.find_or_create(data)`"
puts Event.spigot.find_or_create(event_data.first(3)).inspect

puts "\nSpigot has used the ActiveUser spigot map to create users for each event"
puts ActiveUser.all.map { |user| "#{user.id}: #{user.username}" }

puts "\nEnjoy!"

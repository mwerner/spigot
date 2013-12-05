# Spigot

[![Build Status](https://travis-ci.org/mwerner/spigot.png?branch=master)](https://travis-ci.org/mwerner/spigot)
[![Code Climate](https://codeclimate.com/github/mwerner/spigot.png)](https://codeclimate.com/github/mwerner/spigot)

Spigot is an attempt to bring some sanity to consuming external API data. Without Spigot, you need
to do this manual mapping at creation, such as:

    Pull.where(number: pull.number).first_or_initialize.tap do |t|
      head, base = pull['head'], pull['base']
      links = pull._links
      t.title      = pull['title']
      t.body       = pull['body']
      t.url        = links.html.href
      t.head_ref   = head['ref']
      t.head_sha   = head['sha']
      t.base_ref   = base['ref']
      t.base_sha   = base['sha']
      t.save
    end

This becomes particularly difficult as you start having multiple external sources for the same resource (ex: users from twitter and facebook).
Spigot uses a ruby api to map the data you receive to the columns of your database. As a result, you're
able to convey a mapping of their structure into your attributes in a concise format. Afterwards, you can accomplish the above work in a simple statement:

    Pull.find_or_create_by_api(:github, pull)

Much better. [Read More](https://github.com/mwerner/spigot/wiki)

## Example

    # Our Model
    class User < ActiveRecord::Base
      include Spigot::Base
    end

    # Api Data Received
    data = JSON.parse("{\"full_name\":\"Dean Martin\",\"login\":\"dino@amore.io\",\"token\":\"abc123\"}")

    # Spigot configuration
    Spigot.define do
      resource :user do
        full_name :name
        login :email
        token :auth
      end
    end

    # Usage
    User.find_or_create_by_api(:github, data).inspect
    #=> #<User id: 1, name: "Dean Martin", email: "dino@amore.io", auth: "abc123">

## Future

Features to be added in the future:

- Callbacks
- Specifying local methods instead of attributes

## Installation

Add this line to your application's Gemfile:

    gem 'spigot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spigot

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

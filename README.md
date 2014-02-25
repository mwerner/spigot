# Spigot

[![Build Status](https://travis-ci.org/mwerner/spigot.png?branch=master)](https://travis-ci.org/mwerner/spigot, "Travis CI")
[![Code Climate](https://codeclimate.com/github/mwerner/spigot.png)](https://codeclimate.com/github/mwerner/spigot, "Code Climate")
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/mwerner/spigot/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

Spigot is an attempt to bring some sanity to consuming external API data. Without Spigot, you need
to do this manual mapping at creation, such as:

    if params[:data].present?
      data = params[:data]
      record = User.where(external_id: data[:id]).first

      if record.nil?
        url = "https://github.com/#{data[:login]}"

        user = User.new({
          name: data[:first_name],
          email: data[:email_address],
          url: url
        })

        if data[:profile].present?
          user.bio = data[:profile][:text]
        end

        user.save!
      end
    end

This becomes particularly difficult as you start having multiple external sources for the same resource (ex: users from both twitter and facebook).

Spigot uses a ruby api to map the data you receive to the columns of your database. As a result, you're
able to convey a mapping of their structure into your attributes in a concise format. Afterwards, you can accomplish the above work in a simple statement:

    User.find_or_create_by_api(params[:data])

Much better.

[Read More](http://mwerner.github.io/spigot/)

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

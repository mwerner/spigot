# Spigot

Spigot is an attempt to bring some sanity to consuming external API data. Without Spigot, you need
to do this manual mapping at creation, such as:

    Pull.where(number: pull.number).first_or_initialize.tap do |t|
      t.title      = pull.title
      t.body       = pull.body
      t.url        = pull._links.html.href
      t.head_ref   = pull.head.ref
      t.head_sha   = pull.head.sha
      t.base_ref   = pull.base.ref
      t.base_sha   = pull.base.sha
    end

Spigot reads config files in an expected format to map the data you receive to the columns of your database.
This get's particularly difficult as you start having multiple sources for the same resource (ex: users).

Spigot is able to do the translation for you and put the API data into a language your implementation understands.
This leaves you with a simple statement to accomplish the same as above:

    Pull.find_or_create_by_api(:github, pull)

Much better.

## Example

    # Our Model
    class User < ActiveRecord::Base
      include Spigot::Base
    end

    # Api Data Received
    data = {"full_name":"Dean Martin","login":"dino@amore.io","token":"abc123"}

    # Spigot yaml file to map this data correctly
    user:
      full_name: name
      login: email
      token: auth

    # Usage
    User.find_or_create_by_api(:github, data).inspect
    #=> #<User id: 1, name: "Dean Martin", email: "dino@amore.io", token: "abc123">

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

# Spigot

Spigot provides a clean interface translating API data into context relevant objects

## Installation

Add this line to your application's Gemfile:

    gem 'spigot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spigot

## Usage

You can express the mapping between your model's data and the data received from an api in
a yaml file. The mappings follow the structure of the data received. Any attribute you wish
to retain, assign the name of the attribute on your model to that key.

Basic example:

    # Our Model
    class User
      include Spigot::Model
      attr_accessor :name, :email, :auth
    end

    # Api Data Received
    data = {"full_name":"Dean Martin","login":"dino@amore.io","token":"abc123"}

    # Spigot yaml file to map this data correctly
    user:
      full_name: name
      login: email
      token: auth

    # Usage
    User.new_by_api(data).inspect
    #=> #<User:0x007ffa2918c7b8 @name="Dean Martin", @email="dino@amore.io", @auth="abc123">

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

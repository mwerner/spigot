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

Remember, the key is their attribute, the value is yours:

    user:
      login: 'email'
      full_name: 'name'

Reads as: "For Users, their `login` is my `email` and their `full_name` is my `name`"

Basic example:

    # Our Model
    class User
      include Spigot::Base
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

## Map Format

Spigot allows for a very simple map of api attributes as well as sophisticated options on a key
by key basis. Below are a few examples:

##### Basic

    user:
      name: 'full_name'
      email: 'login'
      username: 'username'

##### Multiple Resources

Spigot will look up the map for the name of the class implementing the method. This let's you map
several of your resources that you're getting from the same service.

    user:
      name: 'full_name'
      email: 'login'
      username: 'username'

    post:
      title: 'title'
      body: 'description'
      created_at: 'timestamp'

##### Options

If you provide a hash to the key instead of a string, Spigot will look for an options key named `spigot`
in the hash provided. Those options let you denote additional options for that resource, such as marking
the identification in the data received.

    user:
      name: 'full_name'
      email: 'login'
      username: 'username'
      spigot:
        primary_key: 'service_id'
        foreign_key: 'id'

## Configuration

There are a handful of options that let you make spigot work the way you need.

    options_key:
      The key which Spigot uses for configuring a resource map.
      type:    String
      default: 'spigot'

    path:
      The directory which holds all the yaml files for the implemented services
      type:    String
      default: 'config/spigot'

    translations:
      A map that, if present, overrides the resource maps found in the `path` directory
      type:    Hash
      default: nil

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

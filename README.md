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

You express the mapping between your model's data and the data received from an API in
a yaml file. The mappings follow the structure of the data received. Any attribute you wish
to retain, assign the name of your model's attribute to the name of the key received.

Remember, the key is their attribute, the value is yours:

    user:
      login: 'email'
      full_name: 'name'

Reads as: "For Users, their `login` is my `email` and their `full_name` is my `name`"

## Example

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

Each Spigot map file represents one service, with as many resources defined as you like.

##### Basic Map

    user:
      name: 'full_name'
      email: 'login'
      username: 'username'

##### Multiple Resources

Spigot will look up the map for the name of the class implementing the method. This let's you map
several of your resources that you're getting from the same service.

    # ./config/github.yml
    user:
      name: 'full_name'
      email: 'login'
      username: 'username'

    post:
      title: 'title'
      body: 'description'
      created_at: 'timestamp'

##### Options

Spigot will look for an options key named `spigot` in the defined map.
Those options let you configure additional options for that resource,
such as denoting the identification in the data received.

    user:
      name: 'full_name'
      email: 'login'
      username: 'username'
      spigot:
        primary_key: 'service_id'
        foreign_key: 'id'

## ActiveRecord

If you include Spigot on an ActiveRecord class, you get a few more methods.

##### `find_by_api`

This uses the primary key defined in that resource's options to query the database
with the value taken from the api data. (**Note** Does not update any values on the
record received from the database.)

    # Spigot yaml file for the github service
    user:
      full_name: name
      login: email
      token: auth
      spigot:
        primary_key: email

    # API Data
    data = {"full_name":"Dean","login":"dino@amore.io","token":"bcd456"}

    #=> User.find_by_api(:github, data)
    User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."email" = 'dino@amore.io' ORDER BY "users"."id" ASC LIMIT 1
    #=> #<User id: 1, name: "Dean Martin", email: "dino@amore.io", token: "abc123">

##### `find_all_by_api`

Operates just like `find_by_api`, but returns all matches on the primary key. The method
returns an `ActveRecord::Relation` allowing you to chain other constraints if you need.

    # Spigot yaml file for the github service
    user:
      full_name: name
      login: email
      token: auth
      spigot:
        primary_key: full_name

    # API Data
    data = {"full_name":"Dean","login":"dino@amore.io","token":"bcd456"}

    #=> User.find_all_by_api(:github, data)
    User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."name" = 'Dean'
    => #<ActiveRecord::Relation [#<User id: 1, name: "Dean", email: "dino@amore.io", token: "abc123">, #<User id: 2, name: "Dean", email: "minerals@notrocks.io", token: '92fnd'>]>

##### `create_by_api`

Creates a record in your database using the provided API data, without doing
any kind of query before, beyond your model's defined validations. Notice the
creation does not use any of the API that isn't defined in the map.

    # Spigot yaml file for the github service
    user:
      full_name: name
      login: email
      token: auth
      spigot:
        primary_key: email

    # API Data
    data = {"full_name":"Frank Sinatra","login":"live@tilidie.io","id":"3"}

    #=> User.create_by_api(:github, data)
    SQL (0.1ms)  INSERT INTO "users" ("name", "email") VALUES (?, ?)  [["name", "Frank Sinatra"], ["email", "live@tilidie.io"]]
    => #<User id: 4, name: "Frank Sinatra", email: "live@tilidie.io", token: nil>

##### `update_by_api`

Updates a record in your database. If no record matching the primary key is found, nothing happens.

    # Spigot yaml file for the github service
    user:
      full_name: name
      login: email
      token: auth
      spigot:
        primary_key: email

    # API Data
    data = {"full_name":"Dino Baby","login":"dean@amore.io","token":"bcd456"}

    #=> User.update_by_api(:github, data)
    User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."email" = 'livetilidie' ORDER BY "active_users"."id" ASC LIMIT 1
    SQL (0.1ms)  UPDATE "users" SET "name" = ?, token = ? WHERE "users"."id" = 3  [["name", "Dino Baby"], ["token", "bcd456"]]
    => #<User id: 3, name: "Dino Baby", email: "dean@amore.io", token: "bcd456">

##### `find_or_create_by_api`

Query the database to find an existing record. If none is found, create one with the provided API data.

##### `create_or_update_by_api`

Query the database to find an existing record. If a record is found, update
the record with the received API data. If no record is found, create one with
the provided API data.

## Configuration

There are a handful of options that let you make spigot work the way you need.

    logger:
      Specify a logger you would like Spigot to log to.
      type:    Object
      default: Logger.new(STDOUT)

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

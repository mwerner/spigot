# Spigot

[![Build Status](https://travis-ci.org/mwerner/spigot.png?branch=master)](https://travis-ci.org/mwerner/spigot "Travis CI")
[![Code Climate](https://codeclimate.com/github/mwerner/spigot.png)](https://codeclimate.com/github/mwerner/spigot "Code Climate")
[![Inline docs](http://inch-pages.github.io/github/mwerner/spigot.png)](http://inch-pages.github.io/github/mwerner/spigot)
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

This becomes particularly difficult as you start having multiple external sources for the same resource (eg: users from both twitter and facebook).

Spigot produces a map of the raw API data you receive to columns in your database. As a result, you're able to parse their data structure into meaningful attributes in a very concise expression. This turns the previous code block into the following statement:

    User.find_or_create_by_api(params[:data])

Much better.

## Installation

Add this line to your application's Gemfile:

    gem 'spigot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spigot

## Setup

Spigot is configured using simple ruby blocks. You just create an initializer, which evaluates your Spigot definition block to be ready for any data you throw at it.

    # config/initializers/spigot.rb
    Spigot.define do
      service :github do
        resource :pull_request do
          id      :github_id
          number  :number
          created :created_at
        end
      end
    end

This `define` block establishes a `pull_request` resource that is sourced by the `github` service. When you include the Spigot mixin to the `PullRequest` model, the class will gain the ability to parse raw pull request data as received from the Github API.

    class PullRequest < ActiveRecord::Base
      include Spigot::Base
    end

    PullRequest.create_by_api(github: params[:pull_request])

## Services

Services are the source from which you are receiving the data you're consuming. By specifying the service which you are using, you're able to accurately map the same resource from multiple sources (such as a User from Twitter and Facebook's API data formats).

Inside your service block you must further define a `resource`. Any API data that you map can only be attributed to a resource in your app.

It is not required to specify a service. You only need to do so if you need to parse the same resource data from multiple services. If you are not parsing multiple services, you can instead define your spigot map with only the resource definition:

    Spigot.define do
      resource :pull_request do
        id      :github_id
        number  :number
        created :created_at
      end
    end

Then, when invoking the methods on the model, you do not need to specify a service when passing in the data.

    class PullRequest < ActiveRecord::Base
      include Spigot::Base
    end

    PullRequest.create_by_api(params[:pull_request])

## Resources

A resource is a model in your app that will receive the parsed data provided by spigot. These resources are defined using a ruby block:

    Spigot.define do
      resource :user do
        login   :username
        name    :full_name
        created :created_at
      end
    end

The method you are calling within the block corresponds to the API data key you are attempting to access. The symbol you specify, or pass to the function, corresponds to your database table attribute to which the value will be assigned.

A good way to remember which is which is to say (from the above example) "Their `login` is my `username`. Their `name` is my `full_name`".

## Parsing Data

When Spigot parses data, it will read the resource definition present in your Spigot map. It will format the raw API data which passed in, and return a hash of data in the format the calling model can understand.

Looking at an example:

    Spigot.resource(:pull_request) do
      id      :github_id
      metadata do
        number  :number do |attr|
          "##{attr}"
        end
      end
      author  User
      created :created_at
    end

There are several things happening in this definition, let's look at each one.

**Nested block**

If you have a nested block, Spigot will dig down into the API data, to retreive the keys specified inside the block.

    data = params[:pull_request]
    if data[:metadata].present?
      number = data[:metadata][:number]
    end

**Attribute block**

When you pass a block to an attribute mapping, that block will be executed on the value found at that location in the API data. You can use this to manipulate and massage the data into exactly what you'd like to assign to your attribute. In this case we're prepending a hashtag before the pull request number.

    number = data[:metadata][:number]
    pr.number = "##{number}"

**Nested Resource**

If the API data you are receiving has an associated resource which you would also like to capture, you can pass a class inside the resource block. Spigot will recognize that `User` has a defined Spigot map and will use it to create a user. Once the nested data has been parsed and used to create a user, Spigot will merge a key value pair associating the created user's id to the API data which `PullRequest` will use.

    userdata = data.delete(:author)
    user = User.find_or_create_by_api(userdata)
    data.merge!(user_id: user.id)
    
**Resulting Data**

With the above example, this is the data which would be parsed:

    # Original
    { id: 123, metadata: {number: 456}, author: { id: 987, login: 'mwerner' }, created: '2000-04-01 00:01:00' }
    
    # Parsed data, passed to PullRequest
    { github_id: 123, number: '#456', user_id: 1, created_at: '2000-04-01 00:01:00' }

**Passing Arrays of data**

Anytime you are parsing an array of data, Spigot will iterate over each element of the array and run the invoked function on each item. It will then return an array of objects which have been created for each element of the array.

## Abbreviated Setup

If you are only consuming one resource from one service, you can use abbreviated syntax to make your Spigot implementation more concise. The following two code blocks are equivalent:

    Spigot.define do
      resource :user do
        login   :username
        created :created_at
      end
    end

    Spigot.resource :user do
      login   :username
      created :created_at
    end

This method can be used for both `service` and `resource`.

## Alternative Syntax

Every class which you include `Spigot::Base` gains a variety of methods to find or save data. These methods can be accessed by a proxy object included on the class. This provides an object that contains all the parsing logic, as well as a more concise syntax.

    # No service specified
    client = PullRequest.spigot
    client.find_or_create(data)

    # Using the :github service
    github = PullRequest.spigot(:github)
    github.find_or_create(data)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

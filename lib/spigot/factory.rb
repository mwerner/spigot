module Spigot
  class Factory

    ## Factory
    #
    # Spigot::Factory is responsible for the instantiation and creation
    # of objects with the formatted data received from Spigot::Translator.

    attr_reader :resource, :data

    # #initialize(resource, data)
    # Method to initialize a factory.
    #
    # @param resource [Object] This is the class implementing the factory.
    # @param data     [Hash]   The already formatted data used to produce the object.
    def initialize(resource, data)
      @resource = resource
      @data     = data
      return instantiate
    end

    # #instantiate
    # Executes the initialize method on the implementing resource with formatted data
    def self.instantiate
      resource.new(data)
    end

    # #create
    # Executes the create method on the implementing resource with formatted data
    def self.create
      resource.create(data)
    end

  end
end

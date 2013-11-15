module Spigot
  class Record

    ## Record
    #
    # Spigot::Record is responsible for the instantiation and creation
    # of objects with the formatted data received from Spigot::Translator.

    attr_reader :resource, :record, :data

    # #initialize(resource, data)
    # Method to initialize a record.
    #
    # @param resource [Object] This is the class implementing the record.
    # @param data     [Hash]   The already formatted data used to produce the object.
    # @param record   [Object] Optional record of `resource` type already in database.
    def initialize(resource, data, record=nil)
      @resource = resource
      @data     = data
      @record   = record
    end

    ## #instantiate(resource, data)
    # Executes the initialize method on the implementing resource with formatted data.
    #
    # @param resource [Object] This is the class implementing the record.
    # @param data     [Hash]   The already formatted data used to produce the object.
    def self.instantiate(resource, data)
      new(resource, data).instantiate
    end

    ## #create(resource, data)
    # Executes the create method on the implementing resource with formatted data.
    #
    # @param resource [Object] This is the class implementing the record.
    # @param data     [Hash]   The already formatted data used to produce the object.
    def self.create(resource, data)
      new(resource, data).create
    end

    ## #update(resource, data)
    # Assigns the formatted data to the resource and saves.
    #
    # @param resource [Object] This is the class implementing the record.
    # @param record   [Object] Optional record of `resource` type already in database.
    # @param data     [Hash]   The already formatted data used to produce the object.
    def self.update(resource, record, data)
      new(resource, data, record).update
    end

    ## #instantiate
    # Executes the initialize method on the implementing resource with formatted data.
    def instantiate
      resource.new(data)
    end

    ## #create
    # Executes the create method on the implementing resource with formatted data.
    def create
      resource.create(data)
    end

    ## #update
    # Assigns the formatted data to the resource and saves.
    def update
      record.assign_attributes(data)
      record.save! if record.changed?
    end

  end
end

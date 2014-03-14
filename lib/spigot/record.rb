module Spigot
  class Record

    ## Record
    #
    # Spigot::Record is responsible for the instantiation and creation
    # of objects with the formatted data received from Spigot::Translator.

    attr_reader :service, :resource, :record, :data, :map

    # #initialize(resource, data)
    # Method to initialize a record.
    #
    # @param resource [Object] This is the class implementing the record.
    # @param data     [Hash]   The already formatted data used to produce the object.
    # @param record   [Object] Optional record of `resource` type already in database.
    def initialize(service, resource, data, record=nil)
      @resource     = resource
      @data         = data
      @record       = record
      @service      = service

      proxy = resource.spigot(service)
      @map          = proxy.map if proxy.present?
      @associations = map ? map.associations : []
    end

    ## #instantiate(resource, data)
    # Executes the initialize method on the implementing resource with formatted data.
    #
    # @param resource [Object] This is the class implementing the record.
    # @param data     [Hash]   The already formatted data used to produce the object.
    def self.instantiate(service, resource, data)
      new(service, resource, data).instantiate
    end

    ## #create(resource, data)
    # Executes the create method on the implementing resource with formatted data.
    #
    # @param resource [Object] This is the class implementing the record.
    # @param data     [Hash]   The already formatted data used to produce the object.
    def self.create(service, resource, data)
      new(service, resource, data).create
    end

    ## #update(resource, data)
    # Assigns the formatted data to the resource and saves.
    #
    # @param resource [Object] This is the class implementing the record.
    # @param record   [Object] Optional record of `resource` type already in database.
    # @param data     [Hash]   The already formatted data used to produce the object.
    def self.update(service, resource, record, data)
      new(service, resource, data, record).update
    end

    ## #instantiate
    # Executes the initialize method on the implementing resource with formatted data.
    def instantiate
      resource.new(data)
    end

    ## #create
    # Executes the create method on the implementing resource with formatted data.
    def create
      data.is_a?(Array) ? create_by_array : create_by_hash(data)
    end

    ## #update
    # Assigns the formatted data to the resource and saves.
    def update
      record.assign_attributes(data)
      record.save! if record.changed?
    end

    private

    def create_by_array
      data.map{|record| create_by_hash(record) }
    end

    def create_by_hash(record)
      resolve_associations(record) if @associations.any?
      resource.create(record)
    end

    def resolve_associations(record)
      @associations.each do |association|
        submodel = association.instance_variable_get(:@value)

        key = submodel.name.underscore.to_sym
        submodel_data = record.delete(key)
        if submodel_data
          object = Record.create(service, submodel, submodel_data)
          record.merge!("#{key}_id".to_sym => object.id)
        end
      end
    end

  end
end

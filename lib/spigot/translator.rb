module Spigot
  class Translator
    ## Translator
    #
    # Translator looks up the key for the resource class name of the calling class,
    # then translates the data received into the format described by the Spigot definition
    #
    # Relevant Configuration:
    # config.options_key  => The key which the Translator uses to configure a resource_map.

    attr_reader :service, :resource
    attr_accessor :data

    OPTIONS = %w(primary_key).freeze

    ## #initialize(resource, service=nil, data={})
    # Method to initialize a translator.
    #
    # @param resource [Object] This is the class implementing the translator.
    # @param service  [Symbol] Translation map specific to incoming data.
    # @param data     [Hash] Data in the format received by the api (optional).
    def initialize(resource, service = nil, data = {})
      @service = service
      @resource = resource.is_a?(Class) ? resource : resource.class
      raise InvalidResourceError, 'You must provide a calling resource' if resource.nil?
      @data = data || {}
    end

    ## #format
    # Formats the hash of data passed in to the format specified in the Spigot defintion.
    def format
      @format ||= data.is_a?(Array) ? data.map { |el| parse(el) } : parse(data)
    end

    ## #conditions
    # The conditions used when querying the database for an existing record
    def conditions
      values = []
      if format.is_a?(Array)
        values = format.map { |item| item[primary_key] }
      else
        values = format[primary_key]
      end

      { primary_key => values }
    end

    ## #options
    # Available options per resource.
    def options
      @options ||= resource_map.instance_variable_get(:@options)
    end

    # @primary_key:
    #   Default: "#{service}_id"
    #   Name of the column in your local database that serves as id for an external resource.
    def primary_key
      options.primary_key || "#{service}_id"
    end

    ## #resource_map
    # Return the mapped resource object for the current service and resource
    def resource_map
      return @resource_map if defined?(@resource_map)
      resource_key = resource.to_s.underscore
      @resource_map = service_map[resource_key]
      raise MissingResourceError, "There is no #{resource_key} resource_map" if @resource_map.nil?
      @resource_map
    end

    def resource_map?(key)
      service_map[key.to_s.underscore]
    end

    private

    def parse(dataset)
      formatted = {}
      resource_map.definitions.each do |rule|
        result = rule.parse(dataset)
        formatted.merge!(result)
      end
      formatted
    end

    def service_map
      return {} if Spigot.config.map.nil?

      @service_map = Spigot.config.map.service(service || :any)
      if @service_map.nil?
        if service.nil?
          raise MissingResourceError, "There is no #{resource.to_s.underscore} resource_map"
        else
          raise InvalidServiceError, "No #{resource.to_s} definition found for #{service}"
        end
      end

      @service_map
    end
  end
end

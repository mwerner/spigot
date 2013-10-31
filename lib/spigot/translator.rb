require 'yaml'

module Spigot
  class Translator

    ## Translator
    #
    # Translator reads the yaml file in the spigot config directory for
    # a given service. It looks up the key for the resource class name
    # passed in, then translates the data received into the format described
    # in the yaml file for that resource
    #
    # Relevant Configuration:
    # config.options_key  => The key which the Translator uses to configure a resource mapping
    # config.path         => The path which the Translator will look in to find the mappings
    # config.translations => A hash that overrides any mappings found in the `path` directory

    attr_reader :service, :resource
    attr_accessor :data

    OPTIONS = %w(primary_key foreign_key).freeze

    # #initialize(service, resource, data)
    # Method to initialize a translator.
    #
    # @param service [Symbol] Service which will be doing the translating. Must have a corresponding yaml file
    # @param resource [Object] This is the class using the translator.
    # @param data [Hash] Data in the format received by the api (optional)
    def initialize(service, resource, data={})
      @service = service
      raise InvalidServiceError, 'You must provide a service name' if service.nil? || service == ''
      @resource = resource.is_a?(Class) ? resource : resource.class
      raise InvalidResourceError, 'You must provide a calling resource' if resource.nil?
      @data = data || {}
    end

    ## #format
    # Formats the hash of data passed in to the format specified in the yaml file
    def format
      formatted = {}
      data.each_pair do |key, val|
        next if key == Spigot.config.options_key
        attribute = mapping[key]
        formatted.merge!(attribute.to_sym => data[key]) unless attribute.nil?
      end
      formatted
    end

    ## #id
    #
    # The value at the foreign_key attribute specified in the resource options, defaults to 'id'
    def id
      @id ||= lookup foreign_key
    end

    ## #lookup(attribute)
    #
    # Find the value in the unformatted api data that matches the passed in key
    #
    # @param service [Symbol] The key pointing to the value you wish to lookup
    def lookup(attribute)
      data.each_pair do |key, val|
        return data[key] if key.to_sym == attribute.to_sym
      end
      nil
    end

    ## #options
    #
    # Available options per resource
    #
    # @primary_key:
    #   Default: "#{service}_id"
    #   Name of the column in your local database that serves as id for an external resource
    # foreign_key:
    #   Default: 'id'
    #   Name of the attribute in the unformatted api_data that is the key to that record's id
    def options
      @options ||= mapping['spigot'] || {}
    end

    def primary_key
      options['primary_key'] || "#{service}_id"
    end

    def foreign_key
      options['foreign_key'] || 'id'
    end

    private

    def mapping
      return @mapping if defined?(@mapping)
      @mapping = translations[resource_key]
      raise MissingResourceError, "There is no #{resource_key} mapping for #{service}" if @mapping.nil?
      @mapping
    end

    def resource_key
      resource.to_s.downcase.gsub('::', '/')
    end

    def translations
      Spigot.config.translations || YAML.load(translation_file)
    end

    def translation_file
      begin
        @translation_file ||= File.read(File.join(Spigot.config.path, "#{service.to_s}.yml"))
      rescue Errno::ENOENT => e
        raise MissingServiceError, "There is no service map for #{service} located in #{Spigot.config.path}"
      end
    end

  end
end

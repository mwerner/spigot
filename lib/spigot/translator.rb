require 'yaml'

module Spigot
  class Translator

    ## Translator
    #
    # Translator reads the yaml file in the spigot config directory for
    # a given service. It looks up the key for the resource class name
    # passed in, then translates the data received into the format described
    # in the yaml file for that resource.
    #
    # Relevant Configuration:
    # config.options_key  => The key which the Translator uses to configure a resource mapping.
    # config.path         => The path which the Translator will look in to find the mappings.
    # config.translations => A hash that overrides any mappings found in the `path` directory.

    attr_reader :service, :resource
    attr_accessor :data

    OPTIONS = %w(primary_key foreign_key conditions).freeze

    ## #initialize(service, resource, data)
    # Method to initialize a translator.
    #
    # @param service  [Symbol] Service doing the translating. Must have a corresponding yaml file.
    # @param resource [Object] This is the class using the translator.
    # @param data     [Hash] Data in the format received by the api (optional).
    def initialize(service, resource, data={})
      @service = service
      raise InvalidServiceError, 'You must provide a service name' if service.nil? || service == ''
      @resource = resource.is_a?(Class) ? resource : resource.class
      raise InvalidResourceError, 'You must provide a calling resource' if resource.nil?
      @data = data || {}
    end

    ## #format(custom_map)
    # Formats the hash of data passed in to the format specified in the yaml file.
    #
    # @param custom_map  [Hash] Optional hash that you can prefer to use over the correlated translation.
    # @param custom_data [Hash] Optional data that you can prefer to use over the @data currently on the object.
    def format(custom_map=nil, custom_data=nil)
      map = custom_map || mapping
      dataset = custom_data || data

      if dataset.is_a?(Array)
        dataset.map{|n| translate(map, n) }
      elsif dataset.is_a?(Hash)
        translate(map, dataset)
      end
    end

    ## #id
    # The value at the foreign_key attribute specified in the resource options, defaults to 'id'.
    def id
      @id ||= lookup(foreign_key)
    end

    ## #lookup(attribute)
    # Find the value in the unformatted api data that matches the passed in key.
    #
    # @param attribute [String] The key pointing to the value you wish to lookup.
    def lookup(attribute)
      data.detect{|k, v| k.to_s == attribute.to_s }.try(:last)
    end

    ## #options
    # Available options per resource.
    #
    # @primary_key:
    #   Default: "#{service}_id"
    #   Name of the column in your local database that serves as id for an external resource.
    # @foreign_key:
    #   Default: "id"
    #   Name of the key representing the resource's ID in the data received from the API.
    # @conditions:
    #   Default: nil
    #   Array of attributes included in the database query, these are names of columns in your database.
    def options
      @options ||= mapping[Spigot.config.options_key] || {}
    end

    def primary_key
      options['primary_key'] || "#{service}_id"
    end

    def foreign_key
      options['foreign_key'] || mapping.invert[primary_key] || 'id'
    end

    def conditions
      p_keys = [*(condition_keys.blank? ? primary_key : condition_keys)].map(&:to_s)
      keys   = mapping.select{|k, v| p_keys.include?(v.to_s) }
      format(keys)
    end

    ## #mapping
    # Return a hash of the data map currently being used by this translator, including options.
    def mapping
      return @mapping if defined?(@mapping)
      @mapping = translations[resource_key.to_s]
      raise MissingResourceError, "There is no #{resource_key} mapping for #{service}" if @mapping.nil?
      @mapping
    end

    private

    def translate(map, dataset)
      formatted = {}

      if dataset.is_a?(Array)
        return dataset.map{|element| translate(map, element)}
      else
        dataset.each_pair do |key, val|
          next if key == Spigot.config.options_key
          attribute = map[key.to_s]
          next if attribute.nil?

          result = attribute.is_a?(Hash) ? translate(attribute, val) : val
          formatted.merge! mergeable_content(key, result, map)
        end
      end

      formatted
    end

    def mergeable_content(key, value, map)
      if value.is_a?(Array)
        {key.to_s => value}
      elsif value.is_a?(Hash)
        value
      else
        {map[key.to_s] => value}
      end
    end

    def condition_keys
      options['conditions'].to_s.split(',').map(&:strip)
    end

    def resource_key
      resource.to_s.downcase.gsub('::', '/')
    end

    def translations
      @translations ||= Spigot.config.translations || YAML.load(translation_file)
    end

    def translation_file
      begin
        @translation_file ||= File.read(File.join(Spigot.config.path, "#{service.to_s}.yml"))
      rescue Errno::ENOENT => e
        raise MissingServiceError, "There is no service map for #{service} defined"
      end
    end

  end
end

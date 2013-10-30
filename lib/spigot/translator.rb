require 'yaml'

module Spigot
  class Translator

    ## Translator
    #
    # Translator reads the yaml file in the spigot config directory for
    # a given service. It looks up the key for the resource class name
    # passed in, then translates the data received into the format described
    # in the yaml file for that resource

    attr_reader :service, :resource

    # #initialize(service, resource)
    # Method to initialize a translator.
    #
    # @param service [Symbol] Service which will be doing the translating. Must have a corresponding yaml file
    # @param resource [Object] This is the class using the translator.
    def initialize(service, resource)
      @service = service
      raise InvalidServiceError, 'You must provide a service name' if service.nil? || service == ''
      @resource = resource.is_a?(Class) ? resource : resource.class
      raise InvalidResourceError, 'You must provide a calling resource' if resource.nil?
    end

    # #format(data)
    # Formats the hash of data passed in to the format specified in the yaml file
    #
    # @param data [Hash] Data in the format received by the api
    def format(data)
      return unless data.is_a?(Hash)
      mapping = translations[resource_key]
      raise MissingResourceError, "There is no #{resource_key} mapping for #{service}" if mapping.nil?

      formatted = {}
      data.each_pair do |key, val|
        attribute = mapping[key]
        formatted.merge!(attribute.to_sym => data[key]) unless attribute.nil?
      end
      formatted
    end

    private

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

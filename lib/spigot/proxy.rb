module Spigot
  class Proxy

    ## Proxy
    #
    # Spigot::Proxy provides accessor methods used by the implementation
    # that could be useful for development or custom behavior

    attr_reader :resource, :service

    ## #initialize(resource)
    # Method to initialize a proxy.
    #
    # @param service [String] This is the service that dictates the proxy.
    # @param resource [Object] This is the class implementing the proxy.
    def initialize(service, resource)
      raise MissingServiceError, "No service definition found for #{service}" if Spigot.config.map.service(service).nil?
      @service  = service
      @resource = resource
    end

    ## #translator
    # Instantiate a Spigot::Translator object with the contextual service and resource
    def translator
      Translator.new(service, resource)
    end

    ## #map
    # Return a hash of the data map the current translator is using
    def map
      translator.resource_map
    end

    ## #options
    # Return a hash of any service specific options for this translator. `Spigot.config` not included
    def options
      translator.options || {}
    end

  end
end

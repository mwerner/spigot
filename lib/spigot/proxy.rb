module Spigot
  class Proxy
    ## Proxy
    #
    # Spigot::Proxy provides accessor methods used by the implementation
    # that could be useful for development or custom behavior
    #
    # Usage:
    #
    # User.spigot.find_or_create(data)
    #
    # User.spigot(:twitter).find_or_create(data)

    attr_reader :resource, :service

    ## #initialize(resource)
    # Method to initialize a proxy.
    #
    # @param service [String] This is the service that dictates the proxy.
    # @param resource [Object] This is the class implementing the proxy.
    def initialize(resource, service = nil)
      @service  = service
      @resource = resource
    end

    ## #find
    #  Alias for find_by_api
    def find(params = {})
      resource.find_by_api service_scoped(params)
    end

    ## #find_all
    #  Alias for find_all_by_api
    def find_all(params = {})
      resource.find_all_by_api service_scoped(params)
    end

    ## #create
    #  Alias for create_by_api
    def create(params = {})
      resource.create_by_api service_scoped(params)
    end

    ## #update
    #  Alias for update_by_api
    def update(params = {})
      resource.update_by_api service_scoped(params)
    end

    ## #find_or_create
    #  Alias for find_or_create_by_api
    def find_or_create(params = {})
      resource.find_or_create_by_api service_scoped(params)
    end

    ## #create_or_update
    #  Alias for create_or_update_by_api
    def create_or_update(params = {})
      resource.create_or_update_by_api service_scoped(params)
    end

    ## #translator
    # Instantiate a Spigot::Translator object with the contextual service and resource
    def translator
      Translator.new(resource, service)
    end

    ## #map
    # Return a hash of the data map the current translator is using
    def map
      translator.resource_map
    end

    ## #present?
    # Returns a boolean if the current spigot map has a mapping for the current resource
    def present?
      translator.resource_map?(resource)
    end

    ## #options
    # Return a hash of any service specific options for this translator. `Spigot.config` not included
    def options
      translator.options || {}
    end

    private

    def service_scoped(params = {})
      return params if @service.nil?
      return { @service => params } if Spigot.config.map.nil?

      key, data = Spigot::Map::Service.extract(params)
      return { @service => params } if key.nil?

      if key.to_sym != @service.to_sym
        raise Spigot::InvalidServiceError, 'You cannot specify two services'
      end

      { key => data }
    end
  end
end

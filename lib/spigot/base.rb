require 'active_record'
module Spigot
  module Base
    def self.included(base)
      base.send(:extend, self::ClassMethods)
      base.send(:extend, Spigot::ActiveRecord::ClassMethods) if active_record?(base)
    end

    module ClassMethods
      # #self.new_by_api(params)
      # Instantiate a new object mapping the api data to the calling object's attributes
      #
      # @param params [Hash] Data as received from the api with optional service key
      def new_by_api(params={})
        service, data = Spigot::Map::Service.extract(params)
        translator = Translator.new(self, service, data)
        Record.instantiate(service, self, translator.format)
      end

      # #self.spigot
      # Return a Spigot::Proxy that provides accessor methods to the spigot library
      #
      # @param service [Symbol] Service which pertains to the data being processed on the implementation
      def spigot(service=nil)
        Spigot::Proxy.new(self, service)
      end
    end

    private

    def self.active_record?(klass)
      defined?(ActiveRecord) && klass < ::ActiveRecord::Base
    end
  end
end

module Spigot
  module Model
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      # #self.new_by_api(service, api_data)
      # Instantiate a new object mapping the api data to the calling object's attributes
      #
      # @param service [Symbol] Service which will be doing the translating. Must have a corresponding yaml file
      # @param api_data [Hash] The data as received from the remote api, unformatted.
      def new_by_api(service, api_data)
        data = Translator.new(service, self).format(api_data)
        Factory.new(self, data).output
      end
    end
  end
end

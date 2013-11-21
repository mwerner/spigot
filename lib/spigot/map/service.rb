module Spigot
  module Map
    class Service

      attr_reader :name
      attr_accessor :resources

      @@services = []

      def initialize(name)
        @name = name
        @resources = []
      end

      def self.services
        @@services
      end

      def self.service(name, &block)
        service = Spigot::Map::Service.new(name)
        service.instance_eval(&block) if block_given?
        @@services << service
      end

      def resource(name, &block)
        resources << Spigot::Map::Resource.new(name, &block)
      end

    end
  end
end

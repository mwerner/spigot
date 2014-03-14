module Spigot
  module Map
    class Service
      attr_reader :name
      attr_accessor :resources

      def initialize(name)
        @name = name.to_s.underscore.to_sym
        @resources = []
      end

      def self.service(name, &block)
        service = find(name) || Spigot::Map::Service.new(name)
        service.instance_eval(&block) if block_given?
        current_map.update(name, service)
      end

      def self.resource(name, &block)
        service(:any) { resource(name, &block) }
      end

      def self.find(name)
        current_map.service(name)
      end

      def resource(name, &block)
        resources << Spigot::Map::Resource.new(name, &block)
      end

      def reset
        @resources = []
      end

      def [](name)
        resources.find { |r| r.instance_variable_get(:@name).to_sym == name.to_sym }
      end

      def self.extract(params)
        return params if current_map.nil?
        return [nil, params] if params.is_a?(Array)

        name    = params.keys.first
        service = current_map.service(name)

        if service.nil?
          return [nil, params]
        else
          return [service.name.to_sym, params[name]]
        end
      end

      private

      def self.current_map
        Spigot.config.map
      end
    end
  end
end

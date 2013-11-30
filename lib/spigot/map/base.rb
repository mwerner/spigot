module Spigot
  module Map
    class Base

      attr_reader :services

      def initialize
        @services = []
        Spigot.config.map = self
      end

      def define(&block)
        Spigot::Map::Service.class_eval(&block) if block_given?
      end

      def update(name, service)
        @services.reject!{|s| s.name == name.to_s.underscore.to_sym}
        @services << service
      end

      def reset
        @services = []
      end

      def service(name)
        services.detect{|service| service.name == name.to_s.underscore.to_sym}
      end

      def to_hash
        hash = {};
        services.each do |service|
          hash.merge!(service.name.to_sym => service.resources.map{|r| r.instance_variable_get(:@name) })
        end
        hash
      end

      def inspect
        "#<Spigot::Map::Base #{to_hash.to_s}"
      end
    end
  end
end
